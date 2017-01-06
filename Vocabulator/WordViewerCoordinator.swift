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
    let deck: VocabulatorDeck
    
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
                todo("Handle nextWord action event")
            }
        }
        
        let word = self.deck.words[0]
        let wordVM = WordViewerViewModel(title: self.deck.title, wordIndex: 1, totalWordCount: self.deck.words.count, word: word.word, pronunciation: word.pronunciation, definition: word.definition)
        let wordViewerController = self.managedController.topViewController as! WordViewerViewController
        wordViewerController.viewModel = wordVM
        self.presentingController.present(self.managedController, animated: true, completion: nil)
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
}

struct WordProvider {
    let deck: VocabulatorDeck
    private var currentWordIndex: Int = 0

    var currentWord: VocabulatorWord? {
         return deck.words[currentWordIndex]
    }

    init(deck: VocabulatorDeck) {
        self.deck = deck
    }
    
    mutating func next() -> VocabulatorWord? {
        if currentWordIndex < deck.words.count {
            let word = deck.words[currentWordIndex]
            currentWordIndex += 1
            return word
        }
        return nil
    }
}
