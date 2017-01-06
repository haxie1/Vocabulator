//
//  WordProvider.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/5/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import XCTest
@testable import Vocabulator
class WordProviderTests: VocabulatorModelTests {
    lazy var testDeck: VocabulatorDeck = {
        guard let deck = self.jsonDecks.first else {
            XCTFail("Couldn't get a test deck, can't continue")
            fatalError() // so no return is needed.
        }
        
        return VocabulatorDeck(withJSON: deck)!
    }()
    
    var provider: WordProvider!
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.provider = WordProvider(deck: self.testDeck)
    }
    
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreatingWithADeck() {
        let provider = WordProvider(deck: testDeck)
        XCTAssert(provider.deck.id == testDeck.id)
    }
    
    func testCallingNextTheFirstTimeReturnsTheFirstWord() {
        let nextWord = testDeck.words[0]
        XCTAssert(self.provider.next()?.id == nextWord.id)
    }
    
    func testSubsequentCallsToNextReturnTheNextWord() {
        let nextWord = testDeck.words[1]
        _ = self.provider.next()
        XCTAssert(self.provider.next()?.id == nextWord.id)
    }
    
    func testNextReturnsNilWhenLastWordIsReached() {
        let deck = self.singleWordDeck
        let wordProvider = WordProvider(deck: deck)
        _ = wordProvider.next()
        
        XCTAssertNil(wordProvider.next())
    }
    
    func testCurrentWord() {
        let word = testDeck.words[0]
        XCTAssert(self.provider.currentWord?.id == word.id)
    }
    
    func testCurrentWordReturnsNilIfNoWords() {
        let jsonDeck: [String: Any] = ["id" : testDeck.id.uuidString, "title" : testDeck.title, "words" : []]
        let deck = VocabulatorDeck(withJSON: jsonDeck)!
        let provider = WordProvider(deck: deck)
        XCTAssertNil(provider.currentWord)
    }
    
    func testCurrentWordReturnsLastWordAfterNextIsExahusted() {
        let deck = self.singleWordDeck
        let wordProvider = WordProvider(deck: deck)
        let nextWord = wordProvider.next() // increment the deck index
        _ = wordProvider.next() // increments past the end index of the deck's words.
        
        XCTAssertEqual(nextWord?.id, wordProvider.currentWord?.id)
    }
    
    func testValidWordReturnedAfterAReset() {
        let deck = self.singleWordDeck
        let provider = WordProvider(deck: deck)
        _ = provider.next()
        XCTAssertNil(provider.next())
        provider.reset()
        XCTAssertNotNil(provider.next())
    }
    
    private var singleWordDeck: VocabulatorDeck {
        let word = self.testDeck.words[0]
        let jsonWord: [String: Any] = ["id" : word.id.uuidString, "word" : word.word, "pronunciation": word.pronunciation, "definition": word.definition]
        let jsonDeck: [String : Any] = ["id" : testDeck.id.uuidString, "title": testDeck.title, "words" : [jsonWord]]
        return VocabulatorDeck(withJSON: jsonDeck)!
    }
}
