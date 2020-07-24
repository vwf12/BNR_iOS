//
//  Item.swift
//  Homepwner
//
//  Created by FARIT GATIATULLIN on 21/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class Item: NSObject, Codable {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    var dateCreated: Date
    var isFavorite: Bool
    let itemKey: String
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = Date()
        self.isFavorite = false
        self.itemKey = UUID().uuidString
        
        super.init()
    }
    
    convenience init(random: Bool = false) {
        if random {
            let adjectives = ["Fluffy", "Rusty", "Shiny", "ASDAKDMDAMDAOMDALMDALMDLADWLJNADWDAWJLDEFSEF"]
            let nouns = ["Bear", "Spork", "Mac"]
            
            var idx = arc4random_uniform(UInt32(adjectives.count))
            let randomAdjective = adjectives[Int(idx)]
            
            idx = arc4random_uniform(UInt32(nouns.count))
            let randomNoun = nouns[Int(idx)]
            
            let randomName = "\(randomAdjective) \(randomNoun)"
            let randomValue = Int(arc4random_uniform(100))
            let randomSerialNumber = UUID().uuidString.components(separatedBy: "-").first!
            
            self.init(name: randomName,
                      serialNumber: randomSerialNumber,
                      valueInDollars: randomValue)
        } else {
            self.init(name: "", serialNumber: nil, valueInDollars: 0)
        }
    }
    
    enum Category {
        case electronics
        case clothing
        case book
        case other
    }
    
    var category = Category.other
    
    enum CodingKeys: String, CodingKey {
        case name
        case valueInDollars
        case serialNumber
        case dateCreated
        case category
        case isFavorite
        case itemKey
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(valueInDollars, forKey: .valueInDollars)
        try container.encode(serialNumber, forKey: .serialNumber)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(itemKey, forKey: .itemKey)
        
        switch category {
        case .electronics:
            try container.encode("electronics", forKey: .category)
        case .clothing:
            try container.encode("clothing", forKey: .category)
        case .book:
            try container.encode("book", forKey: .category)
        case .other:
            try container.encode("other", forKey: .category)
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        valueInDollars = try container.decode(Int.self, forKey: .valueInDollars)
        serialNumber = try container.decode(String.self, forKey: .serialNumber)
        dateCreated = try container.decode(Date.self, forKey: .dateCreated)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        itemKey = try container.decode(String.self, forKey: .itemKey)
        
        let categoryString = try container.decode(String.self, forKey: .category)
        switch categoryString {
        case "electronics":
            category = .electronics
        case "clothing":
               category = .clothing
        case "book":
               category = .book
        case "other":
               category = .other
        default:
               category = .other
        }
    }
}
