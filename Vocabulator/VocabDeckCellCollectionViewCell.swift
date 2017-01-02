//
//  VocabPackCellCollectionViewCell.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/1/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

protocol WordDeck {
    var title: String { get }
    var imageName: String { get }
}

class VocabDeckCollectionViewCell: UICollectionViewCell {
    var viewModel: WordDeck? {
        didSet {
            if let deck = self.viewModel {
                self.titleLabel.text = deck.title
                let image = UIImage(named: deck.imageName) ?? #imageLiteral(resourceName: "WordDeckDefault")
                self.imageView.image = image.withRenderingMode(.alwaysTemplate)
            }
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

extension VocabDeckCollectionViewCell {
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
}
