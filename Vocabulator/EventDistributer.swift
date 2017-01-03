//
//  EventDistributer.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

protocol Event {}

typealias EventHandler<T> = (T) -> Void

class EventDistributer {
    static let shared = EventDistributer()
    private(set) var registry: [(uuid: UUID, callback: Any)] = []
    
    @discardableResult func register<T: Event, U: AnyObject>(target: U, handler: @escaping EventHandler<T>) -> UUID {
        let callback = { [weak target] (arg: T) -> Bool in
            if target != nil {
                handler(arg)
                return true
            } else {
                return false
            }
        } as Any
        
        todo("Decide how to map the target and the UUID together in such a way that if the target does go away and has multiple callbacks registered, they will all be removed.")
        
        let reg = (uuid: UUID(), callback: callback)
        self.registry.append(reg)
        return reg.uuid
    }
    
    func unregister(uuid: UUID) {
        guard let index = self.registry.index(where: { $0.uuid == uuid }) else {
            return
        }
        
        self.registry.remove(at: index)
    }
    
    func unregisterAll() {
        self.registry = []
    }
    
    func distribute<T: Event>(event: T) {
        var cleanup: [UUID] = []
        for reg in self.registry {
            if let callback = reg.callback as? (T) -> Bool {
                if !callback(event) {
                    cleanup.append(reg.uuid)
                }
            }
        }
        
        cleanup.forEach { self.unregister(uuid: $0) }
    }
}
