//
//  VocabulatorDataModel.swift
//  Vocabulator
//
//  Created by Kam Dahlin on 1/4/17.
//  Copyright © 2017 Kam Dahlin. All rights reserved.
//

import Foundation

typealias JSON = [String : Any]
protocol JSONMappable {
    init?(withJSON json: JSON)
}

struct VocabulatorDeckCollection: JSONMappable {
    let id: UUID
    let name: String
    let decks: [VocabulatorDeck]
    
    init?(withJSON json: JSON) {
        guard JSONSerialization.isValidJSONObject(json) else {
            return nil
        }
        
        guard let id = UUID(uuidString: json.value("id", "")) else {
            todo("should we throw for this case instead?")
            return nil
        }
        self.id = id
        
        self.name = json.value("title", "Word Decks")
        let jsonDecks: [JSON] = json.value("decks", [])
        
        self.decks = jsonDecks.flatMap { (json) in
            return VocabulatorDeck(withJSON: json)
        }
    }
}

struct VocabulatorDeck: JSONMappable {
    let id: UUID
    let title: String
    let words: [VocabulatorWord]
    
    init?(withJSON json: JSON) {
        guard let id = UUID(uuidString: json.value("id", "")) else {
            return nil
        }
        self.id = id
        self.title = json.value("title", "")
        
        let jsonWords: [JSON] = json.value("words", [])
        self.words = jsonWords.flatMap { (json) in
            return VocabulatorWord(withJSON: json)
        }
    }
}

struct VocabulatorWord: JSONMappable {
    let id: UUID
    let word: String
    let pronunciation: String
    let definition: String
    
    init?(withJSON json: JSON) {
        guard let id = UUID(uuidString: json.value("id", "")) else {
            return nil
        }
        self.id = id
        
        guard let word: String = json.value("word") else {
            return nil
        }
        
        self.word = word
        self.pronunciation = json.value("pronunciation", "")
        guard let def: String = json.value("definition") else {
            return nil
        }
        self.definition = def
    }
}

class VocabulatorDataModel {
    private class DataProvider {
        var collections: [VocabulatorDeckCollection] = []
        
        static let shared = DataProvider()
        static var useDemoData: Bool = false
        
        private init() {
            if DataProvider.useDemoData {
                let url = Bundle.main.url(forResource: "DemoWords", withExtension: "json")!
                if let collection = self.collection(withURL: url) {
                    self.collections.append(collection)
                }
                
            } else {
                todo("Support multiple collection documents")
            }
        }
        
        private func collection(withURL fileURL: URL) -> VocabulatorDeckCollection? {
            guard let data = NSData(contentsOf: fileURL) else {
                return nil
            }
            
            if let json: JSON = try! JSONSerialization.jsonObject(with: data as Data, options: []) as? [String : Any] {
                return VocabulatorDeckCollection(withJSON: json)
            }
            
            return nil
        }
    }
    
    static func collections(useDemoData: Bool = false) -> [VocabulatorDeckCollection] {
        DataProvider.useDemoData = useDemoData
        return DataProvider.shared.collections
    }
    
    static func deck(withID id: UUID) -> VocabulatorDeck? {
        for collection in DataProvider.shared.collections {
            if let aDeck = collection.decks.first(where: { $0.id == id }) {
                return aDeck
            }
        }
        
        return nil
    }
}

extension Dictionary where Value: Any {
    // Once Swift supports generic subscripts, a func won't be necessary
    
    // optional result for a given key with type inferred
    func value<T>(_ key: Key) -> T? {
        return self[key] as? T
    }
    
    // non-optional type for a given key with a default value.
    // Note: technically the same as self.value(forKey: "key") ?? ""
    func value<T>(_ key: Key, _ defaultValue: @autoclosure () -> T) -> T {
        return self[key] as? T ?? defaultValue()
    }
}
