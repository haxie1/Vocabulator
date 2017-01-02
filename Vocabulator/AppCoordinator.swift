//
//  AppCoordinator.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

protocol Coordinator: class {
    var children: [Coordinator] { get set }
    func begin()
    func end()
    
    func push(coordinator: Coordinator)
    func pop() -> Coordinator?
}

extension Coordinator {
    func push(coordinator: Coordinator) {
        guard !self.children.contains( where: { $0 === coordinator } ) else {
            return
        }
        
        self.children.append(coordinator)
    }
    
    func pop() -> Coordinator? {
        return self.children.last
    }
}
// Main app coordinator. It managed the VocabDeckPickerViewController and all other coordinators

class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    let window: UIWindow
    var managedController: UINavigationController?
    
    init(withMainWindow window: UIWindow) {
        self.window = window
    }
    
    convenience init() {
        self.init(withMainWindow: UIWindow())
    }
    
    func begin() {
        let storyboard = UIStoryboard(name: "VocabDeckPicker", bundle: nil)
        guard let nav = storyboard.instantiateInitialViewController() as? UINavigationController else {
            fatalError("Expected a UINavigationController to be loaded from the VocabDeckPicker.storyboard")
        }
        
        self.managedController = nav
        self.window.rootViewController = nav
        self.window.makeKeyAndVisible()
    }
    
    func end() {}
}
