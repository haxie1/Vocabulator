//
//  VocabPackPickerCollectionViewController.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/1/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import UIKit

protocol DeckCollection {
    var title: String { get }
    var decks: [WordDeck] { get }
    var childCount: Int { get }
}

class VocabDeckPickerViewModel {
    let title: String
    private (set) var sections: [DeckCollection] = []
    
    init(withTitle title: String) {
        self.title = title
    }
    
    convenience init() {
        self.init(withTitle: "Vocabulator")
    }
    
    func childCount(forSection section: Int) -> Int {
        return self.sections[section].childCount
    }
    
    func wordDeck(forIndexPath indexPath: IndexPath) -> WordDeck {
        return self.sections[indexPath.section].decks[indexPath.row]
    }
}

class VocabDeckCollectionHeaderView: UICollectionReusableView {
    static var reuseID: String {
        return String(describing: self)
    }
    
    var viewModel: DeckCollection? {
        didSet {
            self.titleLabel.text = viewModel?.title ?? ""
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
}

class VocabDeckPickerCollectionViewController: UICollectionViewController {
    var deckPickerViewModel: VocabDeckPickerViewModel? {
        didSet {
            if self.isViewLoaded && self.view.window != nil {
                self.collectionView?.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.deckPickerViewModel?.title ?? ""
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.deckPickerViewModel?.sections.count ?? 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.deckPickerViewModel?.childCount(forSection: section) ?? 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let wordDeck = self.deckPickerViewModel?.wordDeck(forIndexPath: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VocabDeckCollectionViewCell.reuseID, for: indexPath) as! VocabDeckCollectionViewCell
        cell.viewModel = wordDeck
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            let deckCollection = self.deckPickerViewModel?.sections[indexPath.section]
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: VocabDeckCollectionHeaderView.reuseID, for: indexPath) as! VocabDeckCollectionHeaderView
            header.viewModel = deckCollection
            return header
        default:
            assert(false)
        }
    }

    // MARK: UICollectionViewDelegate
//    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
