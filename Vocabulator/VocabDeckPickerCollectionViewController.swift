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

struct EmptyDeckCollection: DeckCollection {
    let title: String = "No Word Decks"
    let decks: [WordDeck] = []
    let childCount: Int = 0
}

struct DeckCellViewModel: WordDeck {
    let deckID: UUID
    let title: String
    let imageName: String
    
    init(deckID: UUID, title: String, imageName: String = "WordDeck") {
        self.deckID = deckID
        self.title = title
        self.imageName = imageName
    }
}

class VocabDeckPickerViewModel {
    let title: String
    var sections: [DeckCollection] = []
    var bodyBackgroundColor: UIColor {
        return UIColor(colorLiteralRed: (139 / 255), green: (161 / 255), blue: (217 / 255), alpha: 1.0)
    }
    
    init(withTitle title: String) {
        self.title = title
    }
    
    convenience init() {
        self.init(withTitle: "Vocabulator")
    }
    
    class func emptyPicker() -> VocabDeckPickerViewModel {
        let vm = VocabDeckPickerViewModel()
        vm.sections = [EmptyDeckCollection()]
        return vm
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
    private var needsDeferredReload: Bool = false
    var deckPickerViewModel: VocabDeckPickerViewModel? {
        didSet {
            guard let model = deckPickerViewModel else {
                return
            }
            self.applyViewModel(model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = true
        if self.needsDeferredReload {
            self.applyViewModel(self.deckPickerViewModel!)
        }
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
//        return false
//    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let wordDeck = self.deckPickerViewModel?.wordDeck(forIndexPath: indexPath)
        DeckPickerEvents.selectDeck(id: wordDeck!.deckID)
    }
    
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

    private func applyViewModel(_ viewModel: VocabDeckPickerViewModel) {
        if self.isViewLoaded {
            self.title = viewModel.title
            self.collectionView?.backgroundColor = viewModel.bodyBackgroundColor
            self.collectionView?.reloadData()
            self.needsDeferredReload = false
        } else {
            self.needsDeferredReload = true
        }
    }
}
