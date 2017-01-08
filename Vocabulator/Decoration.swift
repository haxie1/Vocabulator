//
//  Decoration.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/5/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

typealias UndoDecoration = () -> Void
protocol Decoration {
    associatedtype Decoratable
    // Apply a decoration to the target, returning a closure that will undo the decoration.
    // access to 'target' in the undo handler should be weak
    @discardableResult func decorate(_ target: Decoratable) -> UndoDecoration
}

// Apply multiple decorations to a target with the ability to undo the composite decoration.
class CompositeDecoration<DecoratableType>: Decoration {
    private var decorations: [AnyDecoration<DecoratableType>] = []
    
    // Not loving this. Would be better to be able to pass the concrete types instead of having to wrap.
    // CompositeDecoration(decorations: Shadow(), RoundedCorner(), ...)
    // So far, can't make the compiler happy trying to do that.
    // For now, wrap.
    init(decorations: AnyDecoration<DecoratableType>...) {
        self.decorations = decorations
    }
    
    func add<T: Decoration>(decoration: T) where T.Decoratable == DecoratableType {
        self.decorations.append(AnyDecoration(decoration))
    }
    
    func decorate(_ target:DecoratableType) -> UndoDecoration {
        var undo: [() -> Void] = []
        for decoration in self.decorations {
            let undoHandler = decoration.decorate(target)
            undo.append(undoHandler)
        }
        return {
            for handler in undo {
                handler()
            }
        }
    }
}

struct AnyDecoration<DecoratableType>: Decoration {
    private let _decorate: (DecoratableType) -> (() -> Void)
    init<T: Decoration>(_ decoration: T) where T.Decoratable == DecoratableType {
        self._decorate = decoration.decorate
    }
    
    func decorate(_ target: DecoratableType) -> UndoDecoration {
        return _decorate(target)
    }
}

