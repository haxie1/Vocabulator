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
    @discardableResult func decorate(_ target: Decoratable) -> () -> Void
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

struct TransparentNavBar: Decoration {
    func decorate(_ target: UIViewController) -> () -> Void {
        target.navigationController?.navigationBar.isTransparent = true
        
        return { [weak target] in
            target?.navigationController?.navigationBar.isTransparent = false
        }
    }
}

struct HideBackButton: Decoration {
    func decorate(_ target: UIViewController) -> () -> Void {
        target.navigationItem.hidesBackButton = true
        let undo = { [weak target] () -> Void in
            target?.navigationItem.hidesBackButton = false
        }
        return undo
    }
}

extension UINavigationBar {
    var isTransparent: Bool {
        set (newValue) {
            if newValue {
                self.setBackgroundImage(UIImage(), for: .default)
                self.shadowImage = UIImage()
                self.isTranslucent = true
            } else {
                self.setBackgroundImage(nil, for: .default)
                self.shadowImage = nil
                self.isTranslucent = false
            }
        }
        
        get {
            return self.isTranslucent
        }
    }
}
