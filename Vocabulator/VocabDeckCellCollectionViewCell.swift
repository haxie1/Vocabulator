//
//  VocabPackCellCollectionViewCell.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/1/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

class VocabDeckCollectionViewCell: UICollectionViewCell {
    @IBInspectable var showsBorder: Bool {
        set (newValue) {
            if newValue {
                self.layer.borderColor = UIColor.gray.cgColor
                self.layer.borderWidth = 0.5
                self.layer.cornerRadius = 4.0
                self.clipsToBounds = true
            } else {
                self.layer.borderColor = UIColor.clear.cgColor
                self.layer.borderWidth = 0.0
            }
        }
        
        get {
            return self.layer.borderWidth > 0.0 && self.layer.borderColor != UIColor.clear.cgColor
        }
    }
    
    static var reuseID: String {
        return String(describing: self)
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override var isHighlighted: Bool {
        set (newValue) {
            super.isHighlighted = newValue
            if newValue {
                self.layer.borderColor = UIColor.blue.cgColor
                self.layer.borderWidth = 1.0
            } else {
                self.layer.borderWidth = 0.5
                self.layer.borderColor = UIColor.gray.cgColor
            }
        }
        get {
            return super.isHighlighted
        }
    }
}
