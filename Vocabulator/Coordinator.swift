//
//  Coordinator.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation
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
