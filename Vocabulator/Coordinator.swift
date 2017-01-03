//
//  Coordinator.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation
protocol Coordinator: class {
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    func begin()
    func end()
    
    func push(coordinator: Coordinator)
    @discardableResult func pop() -> Coordinator?
    
    func childDidEnd()
}

extension Coordinator {
    func push(coordinator: Coordinator) {
        guard !self.children.contains( where: { $0 === coordinator } ) else {
            return
        }
        coordinator.parent = self
        self.children.append(coordinator)
    }
    
    @discardableResult func pop() -> Coordinator? {
        guard self.children.count > 0 else {
            return nil
        }
        
        let child = self.children.removeLast()
        child.parent = nil
        return child
    }
    
    func childDidEnd() {
        // defualt implementation does nothing
        self.pop()
    }
}
