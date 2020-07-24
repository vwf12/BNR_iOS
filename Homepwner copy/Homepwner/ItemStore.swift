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
    var favItems = [Item]()
    let itemArchiveURL: URL = {
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
//    init() {
//        for _ in 0..<10 {
//            createItem()
//        }
//    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    func moveItem(fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
//        Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]
        
//        Remove item frim array
        allItems.remove(at: fromIndex)
        
//        Inser item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
    
//    @objc func saveChanges() -> Bool {
//        print("Saving items to :\(itemArchiveURL)")
//        do {
//    let encoder = PropertyListEncoder()
//    let data = try encoder.encode(allItems)
//            try data.write(to: itemArchiveURL, options: [.atomic])
//        } catch let encodingError {
//            print("Error handling allItems: \(encodingError)")
//        }
//    return false
//    }
    
    @objc func saveChanges() throws {
          print("Saving items to :\(itemArchiveURL)")
          do {
      let encoder = PropertyListEncoder()
      let data = try encoder.encode(allItems)
              try data.write(to: itemArchiveURL, options: [.atomic])
          } catch let encodingError {
              print("Error handling allItems: \(encodingError)")
          }
      }
    
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let items = try unarchiver.decode([Item].self, from: data)
            allItems = items
        } catch {
            print("Error reading in saved items: \(error)")
        }
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
    }
    
    
}
