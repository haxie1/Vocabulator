//
//  AppCoordinator.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

// Main app coordinator. It managed the VocabDeckPickerViewController and all other coordinators
class AppCoordinator: Coordinator {
    weak var parent: Coordinator? = nil
    var children: [Coordinator] = []
    let window: UIWindow
    var managedController: UINavigationController?
    var selectionID: UUID?
    
    fileprivate let showDemoData: Bool = true
    
    init(withMainWindow window: UIWindow) {
        self.window = window
    }
    
    func begin() {
        self.selectionID = EventDistributer.shared.register(target: self) { (event: DeckPickerEvents.DeckSelection) in
            print("got a selection: \(event.deckID)")
            self.presentWordViewer(forSelection: event)
        }
        
        self.loadInitialViewController()
        if !self.window.isKeyWindow {
            self.window.makeKeyAndVisible()
        }
    }
    
    func end() {
        if let id = self.selectionID {
            EventDistributer.shared.unregister(uuid: id)
        }
    }
    
    private func loadInitialViewController() {
        guard self.managedController == nil else {
            // don't do this work if we already loaded the managed vc
            return
        }
        
        let storyboard = UIStoryboard(name: "VocabDeckPicker", bundle: nil)
        guard let nav = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Expected a UINavigationController to be loaded from the VocabDeckPicker.storyboard")
        }
        
        let topVC = nav.topViewController as! VocabDeckPickerCollectionViewController
        self.managedController = nav
        self.window.rootViewController = nav
        topVC.deckPickerViewModel = self.initialViewModel()
    }
    
    private func presentWordViewer(forSelection selection: DeckPickerEvents.DeckSelection) {
        if let controller = self.managedController {
            guard let deck = VocabulatorDataModel.deck(withID: selection.deckID) else {
                assertionFailure("Couldn't find a VocabulatorDeck with the id \(selection)")
                return
            }
            
            let wordViewerCoordinator = WordViewerCoordinator(withPresentingController: controller, deck: deck)
            self.push(coordinator: wordViewerCoordinator)
            wordViewerCoordinator.begin()
        }
    }
}


// Possible that these are just throwaway functions. Certainly the testDeckVM() is.
extension AppCoordinator {
    func initialViewModel() -> VocabDeckPickerViewModel {
        let collections = VocabulatorDataModel.collections(useDemoData: self.showDemoData)
        let vmCollections = collections.map { return DeckCollectionViewModel(with: $0) }
        let vm = VocabDeckPickerViewModel(withTitle: "Vocabulator")
        vm.sections = vmCollections
        return vm
    }
}

struct DeckCollectionViewModel: DeckCollection {
    private let backingCollection: VocabulatorDeckCollection
    var title: String {
        return backingCollection.name
    }
    
    var decks: [WordDeck] {
        return self.backingCollection.decks.lazy.map { (deck) in
            return DeckCellViewModel(deckID: deck.id, title: deck.title)
        }
    }
    
    var childCount: Int {
        return self.backingCollection.decks.count
    }
    
    init(with backingCollection: VocabulatorDeckCollection) {
        self.backingCollection = backingCollection
    }
}
