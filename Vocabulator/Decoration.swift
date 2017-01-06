//
//  Decoration.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/5/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

protocol Decoration {
    associatedtype Decoratable
    
    func decorate(_ type: Decoratable) -> () -> Void
}

struct AnyDecoration<DecoratableType>: Decoration {
    private let _decorate: (DecoratableType) -> (() -> Void)
    init<T: Decoration>(_ decoration: T) where T.Decoratable == DecoratableType {
        self._decorate = decoration.decorate
    }
    
    @discardableResult func decorate(_ target: DecoratableType) -> () -> Void {
        return _decorate(target)
    }
}

struct Shadow: Decoration {
    func decorate(_ type: UIView) -> () -> Void {
        type.layer.masksToBounds = false
        type.layer.shadowOpacity = 0.35
        type.layer.shadowRadius = 6.0
        type.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        type.layer.shouldRasterize = false

        return {
            type.layer.shadowColor = UIColor.clear.cgColor
            type.layer.shadowRadius = 0.0
            type.layer.shadowOpacity = 0.0
            type.layer.masksToBounds = false
            type.layer.shouldRasterize = true
        }
    }
}
