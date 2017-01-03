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
    
    init(withMainWindow window: UIWindow) {
        self.window = window
    }
    
    func begin() {
        
        self.loadInitialViewController()
        if !self.window.isKeyWindow {
            self.window.makeKeyAndVisible()
        }
    }
    
    func end() {}
    
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
        topVC.deckPickerViewModel = self.emptyDeckViewModel()
    }
    
    private func emptyDeckViewModel() -> VocabDeckPickerViewModel {
        return VocabDeckPickerViewModel.emptyPicker()
    }
    
    
}
