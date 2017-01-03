//
//  DeckPickerEvents.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/2/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

class DeckPickerEvents {
    struct DeckSelection: Event {
        let deckID: UUID
    }
    
    static func selectDeck(id: UUID) {
        EventDistributer.shared.distribute(event: DeckSelection(deckID: id))
    }
}

