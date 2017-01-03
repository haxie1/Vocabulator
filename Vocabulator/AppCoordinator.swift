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
    var children: [Coordinator] = []
    let window: UIWindow
    var managedController: UINavigationController?
    var selectionID: UUID?
    
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
        topVC.deckPickerViewModel = self.testDeckVM()
    }
    
    private func presentWordViewer(forSelection selection: DeckPickerEvents.DeckSelection) {
        todo("build the WordViewer Coordinator and push it")
        if let controller = self.managedController {
            let wordViewerSB = UIStoryboard(name: "WordViewer", bundle: nil)
            let rootVC = wordViewerSB.instantiateInitialViewController() as! UINavigationController
            let viewModel = WordViewerViewModel(word: "Dude", pronunciation: "\\dood\\", definition: "A phrase used to refer to a friend")
            let vc = rootVC.topViewController as! WordViewerViewController
            vc.viewModel = viewModel
            controller.present(rootVC, animated: true, completion: nil)
        }
    }
}


// Possible that these are just throwaway functions. Certainly the testDeckVM() is.
extension AppCoordinator {
    fileprivate func emptyDeckViewModel() -> VocabDeckPickerViewModel {
        return VocabDeckPickerViewModel.emptyPicker()
    }
    
    fileprivate func testDeckVM() -> VocabDeckPickerViewModel {
        let decks = [DeckViewModel(deckID: UUID(), title: "Week 1"), DeckViewModel(deckID: UUID(), title: "Week 2")]
        let collection = DeckCollection(title: "Word Decks", decks: decks)
        let deckVM = VocabDeckPickerViewModel()
        deckVM.sections = [collection]
        return deckVM
    }
 
}
