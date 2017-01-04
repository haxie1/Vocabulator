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
    
    init(withPresentingController controller: UINavigationController) {
        self.presentingController = controller
        let storyboard = UIStoryboard(name: "WordViewer", bundle: nil)
        self.managedController = storyboard.instantiateInitialViewController() as! UINavigationController
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
        
        let word = WordViewerViewModel(word: "Funky", pronunciation: "", definition: "A smell or odd thing")
        let wordViewerController = self.managedController.topViewController as! WordViewerViewController
        wordViewerController.viewModel = word
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
