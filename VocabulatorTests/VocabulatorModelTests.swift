//
//  VocabulatorModelTests.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/4/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import XCTest

@testable import Vocabulator

class VocabulatorModelTests: XCTestCase {
    let testData: [String : Any] = ["id" : "E6E24949-895D-4D44-85E7-2FE541D72C0C",
                                          "title" : "Demo Words",
                                          "decks" : [["id" : "ED02DC99-48E7-4ED9-8928-E0DDC669F908",
                                                      "title" : "Week 1",
                                                      "words" : [["id" : "96A05669-359D-4F51-8AFC-C6E36E909A15",
                                                                  "word" : "Audacious",
                                                                  "pronunciation" : "[au·da·cious] adj",
                                                                  "definition" : "Showing a willingness to take risks. “An audacious attack on the company.” Showing an impudent lack of respect. “An audacious move.”"],
                                                                 ["id" : "904BCC15-B2ED-47B8-AB3D-84241EB58365",
                                                                  "word" : "Obdurate",
                                                                  "pronunciation" : "[ob·du·rate ] adj",
                                                                  "definition" : "Stubbornly refusing to change one’s opinion or course of action. “Despite her plea, he remained obdurate.”"]]]]]
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
extension VocabulatorModelTests {
    var jsonCollectionID: String {
        return self.testData.value("id", "")
    }
    
    var jsonCollectionTitle: String {
        return self.testData.value("title", "")
    }
    
    var jsonDecks: [[String : Any]] {
        return self.testData.value("decks", [])
    }
    
    var deckCount: Int {
        return self.jsonDecks.count
    }
}

class VocabulatorDeckCollectionTests: VocabulatorModelTests {
    var collection: VocabulatorDeckCollection!
    
    override func setUp() {
        super.setUp()
        self.collection = VocabulatorDeckCollection(withJSON: self.testData)!
    }
    
    func testCreatesACollectionWithValidJSON() {
        let collection = VocabulatorDeckCollection(withJSON: self.testData)
        XCTAssertNotNil(collection)
    }
    
    func testIDPropertyIsSet() {
        let uuid = UUID(uuidString: self.jsonCollectionID)!
        XCTAssertEqual(self.collection.id, uuid)
    }
    
    func testCollectionIsNilIfIDPropertyIsMissing() {
        let collection = VocabulatorDeckCollection(withJSON: ["id" : "Bogus"])
        XCTAssertNil(collection)
    }
    
    func testTitlePropertyIsSet() {
        XCTAssertEqual(self.collection.name, self.jsonCollectionTitle)
    }
    
    func testDefaultTitleIsUsedIfTileIsMissing() {
        let collection = VocabulatorDeckCollection(withJSON: ["id" : "E6E24949-895D-4D44-85E7-2FE541D72C0C"])
        XCTAssertEqual(collection?.name, "Word Decks")
    }
    
    func testDecksAreCreated() {
        XCTAssert(self.collection.decks.count == self.deckCount)
    }
    
    func testDecksDefaulToEmptyArrayIfNoDecksCouldBeCreated() {
        let collection = VocabulatorDeckCollection(withJSON: ["id" : "E6E24949-895D-4D44-85E7-2FE541D72C0C"])
        XCTAssert(collection?.decks.count == 0)
    }
    
}



class VocabulatorDeckTests: VocabulatorModelTests {
    var jsonDeck: [String : Any] {
        guard let deck = self.jsonDecks.first else {
            XCTFail("Expected at leats one test deck in the data")
            return [:]
        }
        return deck
    }
    
    var jsonID: UUID {
        return UUID(uuidString: self.jsonDeck.value("id", ""))!
    }

    var jsonDeckTitle: String {
        return self.jsonDeck.value("title", "")
    }
    
    var wordCount: Int {
        return self.jsonDeck.value("words", []).count
    }
    
    lazy var deck: VocabulatorDeck = {
        return VocabulatorDeck(withJSON: self.jsonDeck)!
    }()

    override func setUp() {
        super.setUp()
    }
    
    func testCreatesADeckWithValidJSON() {
        let deck = VocabulatorDeck(withJSON: self.jsonDeck)
        XCTAssertNotNil(deck)
    }
    
    func testCreatesADeckWithAID() {
        XCTAssertEqual(self.deck.id, self.jsonID)
    }
    
    func testReturnsNilIfIDCantBeCreated() {
        let deck = VocabulatorDeck(withJSON: ["id" : "BadID"])
        XCTAssertNil(deck)
    }
    
    func testCreatesADeckWithATitle() {
        XCTAssertEqual(self.deck.title, self.jsonDeckTitle)
    }
    
    func testCreatesADeckWithMappedWords() {
        XCTAssert(self.deck.words.count == self.wordCount)
    }
    
    func testCreatesAEmptyArrayIfNoWordsCanBeMapped() {
        let deck = VocabulatorDeck(withJSON: ["id" : "E6E24949-895D-4D44-85E7-2FE541D72C0C"])
        XCTAssert(deck?.words.count == 0)
    }
}



