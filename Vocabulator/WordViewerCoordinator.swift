//
//  WordViewerCoordinator.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/3/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//
import UIKit

class WordViewerEvents {
    enum Action: Event {
        case cancel
        // other event types that 
        case nextWord
        case complete
    }
    
    static func cancel() {
        self.sendAction(event: .cancel)
    }
    
    static func complete() {
        self.sendAction(event: .complete)
    }
    
    static func next() {
        self.sendAction(event: .nextWord)
    }
    
    private static func sendAction(event: Action) {
        EventDistributer.shared.distribute(event: event)
    }
}

class WordViewerCoordinator: Coordinator {
    weak var parent: Coordinator?
    var children: [Coordinator] = []
    private var actionEventsUUID: UUID?
    
    let presentingController: UINavigationController
    let managedController: UINavigationController
    var wordViewerController: WordViewerViewController {
        return self.managedController.topViewController as! WordViewerViewController
    }
    
    let deck: VocabulatorDeck
    lazy var wordProvider: WordProvider = {
        return WordProvider(deck: self.deck)
    }()
    
    init(withPresentingController controller: UINavigationController, deck: VocabulatorDeck) {
        self.presentingController = controller
        let storyboard = UIStoryboard(name: "WordViewer", bundle: nil)
        self.managedController = storyboard.instantiateInitialViewController() as! UINavigationController
        self.deck = deck
    }
    
    func begin() {
        self.actionEventsUUID = EventDistributer.shared.register(target: self) { (action: WordViewerEvents.Action) in
            switch action {
            case .cancel, .complete:
                self.handleCompletion(action: action)
                break
            case .nextWord:
                self.nextWord()
            }
        }
        
        self.wordProvider.reset()
        self.nextWord()
        self.presentingController.present(self.managedController, animated: true, completion: nil)
        _ = TransparentNavBar().decorate(self.managedController.topViewController!)
    }
    
    func end() {
        if let id = self.actionEventsUUID {
            EventDistributer.shared.unregister(uuid: id)
        }
        
        self.presentingController.dismiss(animated: true) { [weak self] in
            self?.parent?.childDidEnd()
        }
    }
    
    private func handleCompletion(action: WordViewerEvents.Action) {
        switch action {
        case .cancel, .complete:
            todo("decide if the child should call end() or if that should be something that the parent does?")
            self.end()
            break
        default:
            break
            // no-op
        }
    }
    
    private func nextWord() {
        if let vm = self.viewModel(for: self.deck) {
            let controller = self.managedController.topViewController as! WordViewerViewController
            controller.viewModel = vm
            return
        }
        // are we done at this point and need to show the success screen?
        todo("Show a completion screen when we have exhaused all the words")
        let storyboard = UIStoryboard(name: "WordViewer", bundle: nil)
        let doneController = storyboard.instantiateViewController(withIdentifier: String(describing: WordSessionCompleteController.self))
        
        self.managedController.pushViewController(doneController, animated: true)
        _ = HiddenBackButton().decorate(doneController)
    }
    
    private func viewModel(for deck: VocabulatorDeck) -> WordViewerViewModel? {
        if let word = self.wordProvider.next() {
            let wordIndex = self.wordProvider.currentWordIndex
            return WordViewerViewModel(title: deck.title, wordIndex:wordIndex , totalWordCount: deck.words.count, word: word.word, pronunciation: word.pronunciation, definition: word.definition)
        }
        return nil
    }
}

class WordProvider {
    let deck: VocabulatorDeck
    private(set) var currentWordIndex: Int = 0
    private var iterator: IndexingIterator<[VocabulatorWord]>
    
    var currentWord: VocabulatorWord? {
        guard !deck.words.isEmpty else {
            return nil
        }
        
        let index = (self.currentWordIndex > 0) ? self.currentWordIndex - 1 : 0
        return deck.words[index]
    }

    init(deck: VocabulatorDeck) {
        self.deck = deck
        self.iterator = self.deck.words.makeIterator()
    }
    
    func next() -> VocabulatorWord? {
        guard let word = self.iterator.next() else {
            return nil
        }
        
        self.currentWordIndex += 1
        return word
    }
    
    func reset() {
        self.currentWordIndex = 0
        self.iterator = self.deck.words.makeIterator()
    }
}
