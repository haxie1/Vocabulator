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
    
    #if DEBUG // Is there a better way to isolate this for testing?
    init() {}
    #else
    private init() {}
    #endif
    
    private(set) var registry: [(uuid: UUID, objectID: ObjectIdentifier, callback: Any)] = []
    
    @discardableResult func register<T: Event, U: AnyObject>(target: U, handler: @escaping EventHandler<T>) -> UUID {
        let callback = { [weak target] (arg: T) -> Bool in
            if target != nil {
                handler(arg)
                return true
            } else {
                return false
            }
        } as Any
        
        // an identifier to unique the target object. Every registered handler for this target will use the same identifier.
        let objectID = ObjectIdentifier(target)
        let reg = (uuid: UUID(), objectID: objectID, callback: callback)
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
        var cleanupID: ObjectIdentifier?
        for reg in self.registry {
            if let callback = reg.callback as? (T) -> Bool {
                if !callback(event) {
                    cleanupID = reg.objectID
                }
            }
            
            if let id = cleanupID, reg.objectID == id {
                cleanup.append(reg.uuid)
            }
        }
        
        cleanup.forEach { self.unregister(uuid: $0) }
    }
}
