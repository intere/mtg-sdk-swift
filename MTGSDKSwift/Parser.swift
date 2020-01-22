//
//  Parser.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 2/27/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

final class ResultsFilter {
    
    /**
     If an array of Card contains cards with identical names, likely due to multiple printings, this function leaves only one version of that card. You will only have one "Scathe Zombie" instead of 5 "Scathe Zombie", the only difference between them being the set they were printed in.
     
     - parameter cards: [Card]
     - returns: [Card] consisting of Cards without duplicate names
 */

    static public func removeDuplicateCardsByName(_ cards: [Card]) -> [Card] {
        var uniqueNames = [String]()
        var uniqueCards = [Card]()
        
        for c in cards {
            if let name = c.name {
                if !uniqueNames.contains(name) {
                    uniqueCards.append(c)
                }
                uniqueNames.append(name)
            }
        }
        
        return uniqueCards
    }
}

public typealias CardMap = [String: Any]

public final class Parser {
    
     static func parseCards(json: JSONResults) -> [Card] {

        guard let cards = json["cards"] as? [CardMap] else {
            debugPrint("MTGSDK Parser parseCards - unexpected json: returning empty array")
            return [Card]()
        }
        
        var cardsArray = [Card]()
        
        for c in cards {
            
            var card = Card()
            
            if let name = c[CardJsonKey.name] as? String {
                card.name = name
            }
            if let names = c[CardJsonKey.names] as? [String] {
                card.names = names
            }
            if let manaCost = c[CardJsonKey.manaCost] as? String {
                card.manaCost = manaCost
            }
            if let cmc = c[CardJsonKey.cmc] as? Int {
                card.cmc = cmc
            }
            if let colors = c[CardJsonKey.colors] as? [String] {
                card.colors = colors
            }
            if let colorIdentity = c[CardJsonKey.colorIdentity] as? [String] {
                card.colorIdentity = colorIdentity
            }
            if let type = c[CardJsonKey.type] as? String {
                card.type = type
            }
            if let supertypes = c[CardJsonKey.supertypes] as? [String] {
                card.supertypes = supertypes
            }
            if let types = c[CardJsonKey.types] as? [String] {
                card.types = types
            }
            if let subtypes = c[CardJsonKey.subtypes] as? [String] {
                card.subtypes = subtypes
            }
            if let rarity = c[CardJsonKey.rarity] as? String {
                card.rarity = rarity
            }
            if let set = c[CardJsonKey.set] as? String {
                card.set = set
            }
            if let setName = c[CardJsonKey.setName] as? String {
                card.setName = setName
            }
            if let text = c[CardJsonKey.text] as? String {
                card.text = text
            }
            if let artist = c[CardJsonKey.artist] as? String {
                card.artist = artist
            }
            if let number = c[CardJsonKey.number] as? String {
                card.number = number
            }
            if let power = c[CardJsonKey.power] as? String {
                card.power = power
            }
            if let toughness = c[CardJsonKey.toughness] as? String {
                card.toughness = toughness
            }
            if let layout = c[CardJsonKey.layout] as? String {
                card.layout = layout
            }
            if let multiverseid = c[CardJsonKey.multiverseid] as? Int {
                card.multiverseid = multiverseid
            }
            if let imageUrl = c[CardJsonKey.imageUrl] as? String {
                card.imageUrl = imageUrl
            }
            if let rulings = c[CardJsonKey.rulings] as? [[String:String]] {
                card.rulings = rulings
            }
            if let foreignNames = c[CardJsonKey.foreignNames] as? [[String:String]] {
                card.foreignNames = foreignNames
            }
            if let printings = c[CardJsonKey.printings] as? [String] {
                card.printings = printings
            }
            if let originalText = c[CardJsonKey.originalText] as? String {
                card.originalText = originalText
            }
            if let originalType = c[CardJsonKey.originalType] as? String {
                card.originalType = originalType
            }
            if let id = c[CardJsonKey.id] as? String {
                card.id = id
            }
            if let loyalty = c[CardJsonKey.loyalty] as? Int {
                card.loyalty = loyalty
            }
            if let format = c[CardJsonKey.gameFormat] as? String {
                card.gameFormat = format
            }
           
            if let releaseDate = c[CardJsonKey.releaseDate] as? String {
                card.releaseDate = releaseDate
            }
            if let legalities = c[CardJsonKey.legalities] as? [[String: String]] {
                for pair in legalities {
                    guard let format = pair["format"],
                        let legality = pair["legality"] else {
                            continue
                    }
                    card.legalities[format] = legality
                }
            }
            
            cardsArray.append(card)
           
        }
        
        debugPrint("MTGSDK cards retreived: \(cardsArray.count)")
        return cardsArray
    }
    
     static func parseSets(json: JSONResults) -> [CardSet] {
        
        guard let cardSets = json["sets"] as? [[String:Any]] else {
            debugPrint("MTGSDK Parser parseSets - unexpected json: returning empty array")
            return [CardSet]()
        }
        
        var sets = [CardSet]()
        
        for s in cardSets {
            var set = CardSet()
            
            if let name = s["name"] as? String {
                set.name = name
            }
            if let code = s["code"] as? String {
                set.code = code
            }
            if let block = s["block"] as? String {
                set.block = block
            }
            if let type = s["type"] as? String {
                set.type = type
            }
            if let border = s["border"] as? String {
                set.border = border
            }
            if let releaseDate = s["releaseDate"] as? String {
                set.releaseDate = releaseDate
            }
            if let magicCardsInfoCode = s["magicCardsInfoCode"] as? String {
                set.magicCardsInfoCode = magicCardsInfoCode
            }
            if let booster = s["booster"] as? [[String]] {
                set.booster = booster
            }
            
            sets.append(set)
        }
        
        debugPrint("MTGSDK sets retreived: \(sets.count)")
        
        return sets
    }
}

extension CardMap {

    subscript(index: Parser.CardJsonKey) -> Any? {
        return self[index.rawValue]
    }
}

public extension Parser {

    /// The keys used by the parser for parsing Card objects.
    enum CardJsonKey: String {
        case cards = "cards"
        case name = "name"
        case names = "names"
        case manaCost = "manaCost"
        case cmc = "cmc"
        case colors = "colors"
        case colorIdentity = "colorIdentity"
        case type = "type"
        case supertypes = "supertypes"
        case types = "types"
        case subtypes = "subtypes"
        case rarity = "rarity"
        case set = "set"
        case setName = "setName"
        case text = "text"
        case artist = "artist"
        case number = "number"
        case power = "power"
        case toughness = "toughness"
        case layout = "layout"
        case multiverseid = "multiverseid"
        case imageUrl = "imageUrl"
        case rulings = "rulings"
        case foreignNames = "foreignNames"
        case printings = "printings"
        case originalText = "originalText"
        case originalType = "originalType"
        case id = "id"
        case loyalty = "loyalty"
        case legalities = "legalities"
        case legalitiesFormat = "format"
        case legalitiesLegality = "legality"
        case gameFormat = "gameFormat"
        case releaseDate = "releaseDate"
    }

}
