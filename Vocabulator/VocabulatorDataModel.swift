//
//  VocabulatorDataModel.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/4/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

protocol VocabulatorDeckCollection {
    var id: UUID { get }
    var name: String { get }
    var decks: [VocabulatorDeck] { get }
}

protocol VocabulatorDeck {
    var id: UUID { get }
    var title: String { get }
    var words: [VocabulatorWord] { get }
}

protocol VocabulatorWord {
    var id: UUID { get }
    var word: String { get }
    var pronunciation: String { get }
    var definition: String { get }
}

class VocabulatorDataModel {
    typealias VocabulatorJSON = [String : AnyObject]
    
}
