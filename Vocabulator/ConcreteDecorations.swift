//
//  ConcreteDecorations.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/7/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

struct Shadow: Decoration {
    func decorate(_ target: UIView) -> UndoDecoration {
        target.layer.masksToBounds = false
        target.layer.shadowOpacity = 0.35
        target.layer.shadowColor = UIColor.gray.cgColor
        target.layer.shadowRadius = 6.0
        target.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        target.layer.shouldRasterize = false
        
        return { [weak target] in
            target?.layer.shadowColor = UIColor.clear.cgColor
            target?.layer.shadowRadius = 0.0
            target?.layer.shadowOpacity = 0.0
            target?.layer.masksToBounds = false
            target?.layer.shouldRasterize = true
        }
    }
}

struct RoundedCorner: Decoration {
    let radius: CGFloat
    init(_ radius: CGFloat = 4.0) {
        self.radius = radius
    }
    
    func decorate(_ target: UIView) -> UndoDecoration {
        let originalRadius = target.layer.cornerRadius
        target.layer.cornerRadius = self.radius
        
        return { [weak target] in
            target?.layer.cornerRadius = originalRadius
        }
    }
}

struct Border: Decoration {
    let color: UIColor
    let width: CGFloat
    
    init(withColor color: UIColor = UIColor.gray, width: CGFloat = 1.0) {
        self.color = color
        self.width = width
    }
    
    func decorate(_ target: UIView) -> UndoDecoration {
        let originalColor = target.layer.borderColor
        let originalWidth = target.layer.borderWidth
        
        target.layer.borderColor = self.color.cgColor
        target.layer.borderWidth = self.width
        
        return { [weak target] in
            target?.layer.borderWidth = originalWidth
            target?.layer.borderColor = originalColor
        }
    }
}
struct TransparentNavBar: Decoration {
    func decorate(_ target: UIViewController) -> UndoDecoration {
        target.navigationController?.navigationBar.isTransparent = true
        
        return { [weak target] in
            target?.navigationController?.navigationBar.isTransparent = false
        }
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

struct HiddenBackButton: Decoration {
    func decorate(_ target: UIViewController) -> UndoDecoration {
        target.navigationItem.hidesBackButton = true
        let undo = { [weak target] () -> Void in
            target?.navigationItem.hidesBackButton = false
        }
        return undo
    }
}

class StyledNavBar: CompositeDecoration<UIViewController> {
    init() {
        super.init(decorations: AnyDecoration(HiddenBackButton()), AnyDecoration(TransparentNavBar()))
    }
}
