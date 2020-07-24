//
//  ItemStore.swift
//  Homepwner
//
//  Created by FARIT GATIATULLIN on 22/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    var itemsWithValueOver50: [Item] {
        return allItems.filter { $0.valueInDollars > 50 }
    }
    
    var itemsWithValueLess50: [Item] {
        return allItems.filter { $0.valueInDollars <= 50 }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    init() {
        for _ in 0..<100 {
            createItem()
        }
    }
   
}
