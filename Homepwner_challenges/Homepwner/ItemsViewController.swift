//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by FARIT GATIATULLIN on 18/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
//    var numOf50: Int!
    
    var itemStore: ItemStore!
    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return itemStore.allItems.count
//    }
    
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
////        Get a new or recycled cell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
//
////        Set the text on the cell with description of the item that is at nth index of items, where n = row this cell will appear on tableview
//        let item = itemStore.allItems[indexPath.row]
//
//        cell.textLabel?.text = item.name
//        cell.detailTextLabel?.text = "$\(item.valueInDollars)"
//
//        return cell
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Over $50"
        default:
            return "Less than $50"
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return itemStore?.itemsWithValueOver50.count ?? 0
        default:
            return itemStore.itemsWithValueLess50.count + 1   // 1 for "No more items!"
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == itemStore.itemsWithValueLess50.count {
            return 44
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell", for: indexPath)
        
        let items: [Item]
        switch indexPath.section {
        case 0:
            items = itemStore.itemsWithValueOver50
        default:
            items = itemStore.itemsWithValueLess50
        }
        
        
        if indexPath.section == 1 && indexPath.row == items.count {
            cell.textLabel?.text = "No more items!"
            cell.detailTextLabel?.text = ""
        } else {
            let item = items[indexPath.row]
            cell.textLabel?.text = item.name
            cell.detailTextLabel?.text = "\(item.valueInDollars)"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
        }
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Get the height of the status bar
        let statusBarHeight = UIApplication.shared.statusBarFrame.height
        
        let insets = UIEdgeInsets(top: statusBarHeight, left: 0, bottom: 0, right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
        //tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFit
        tableView.backgroundView = imageView
    }
}
