//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by FARIT GATIATULLIN on 18/06/2020.
//  Copyright © 2020 vwf. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController {
    
    var itemStore: ItemStore!
    var imageStore: ImageStore!
    var isFiltered: Bool = false
    
    @IBAction func addNewItem(_ sender: UIBarButtonItem) {
// Create a new item and add it to the store
        let newitem = itemStore.createItem()
        
// Figure out where that item is in the array
        if let index = itemStore.allItems.firstIndex(of: newitem) {
            let indexPath = IndexPath(row: index, section: 0)
            
//            Inser this new row into the table
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    @IBAction func toggleFavs(_ sender: UIButton) {
        
        isFiltered = !isFiltered
        let allButFirst = (self.tableView.indexPathsForVisibleRows ?? [])
        self.tableView.reloadRows(at: allButFirst, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         //return itemStore.allItems.count + 1
        print("Count of rows: \(getItems().count)")
        return getItems().count
        //+ 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        Get a new or recycled cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
////        Set the text on the cell with description of the item that is at nth index of items, where n = row this cell will appear on tableview
//        let item = itemStore.allItems[indexPath.row]
//
//        if  indexPath.row == itemStore.allItems.count {
//            cell.textLabel?.text = "No more items!"
//            cell.detailTextLabel?.text = ""
//        } else {
//            cell.textLabel?.text = item.name
//            cell.detailTextLabel?.text = "$\(item.valueInDollars)"
//        }
//        return cell
//    }
        
//        var items: [Item] = itemStore.allItems
//        var filtered = [Item]()
//        filtered = itemStore.allItems.filter { $0.isFavorite == true }

//        if  indexPath.row == items.count {
//            cell.textLabel?.text = "No more items!"
//            cell.detailTextLabel?.text = ""
//        } else {
            let item = getItems()[indexPath.row]
            cell.nameLabel.text = item.name
            if item.isFavorite {
                cell.textLabel?.text? = "⭐️\t\t\(item.name)"
            }
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        switch item.valueInDollars {
        case ..<50:
            cell.valueLabel.textColor = UIColor.green
        default:
            cell.valueLabel.textColor = UIColor.red
        }

 //       }
//        return cell
//            } else {
//            //let filteredItems = items.filter { $0.isFavorite == true }
//            let allButFirst = (self.tableView.indexPathsForVisibleRows ?? [])
//            self.tableView.reloadRows(at: allButFirst, with: .automatic)
//            let item = filtered[indexPath.row]
//            cell.textLabel?.text = item.name
//            tableView.reloadRows(at: [indexPath], with: .automatic)
        
        
        return cell
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backBarButtonItem = UIBarButtonItem(title: "My Items", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 65
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//         If table view is asking to commit a delete command...
        if editingStyle == .delete {
//            let item = itemStore.allItems[indexPath.row]
            let item = getItems()[indexPath.row]
            let title = "Delete \(item.name)?"
            let message = "Are you sure want to delete this item?"
            
            let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            ac.addAction(cancelAction)
            let deleteAction = UIAlertAction(title: "Remove", style: .destructive, handler: { (action) -> Void in
//            Remove the item from the store
            self.itemStore.removeItem(item)
                
//                remove the item's image from the image store
                self.imageStore.deleteImage(forKey: item.itemKey)
            
//            Also remove that row from the table view with an animation
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        })
            ac.addAction(deleteAction)
            
//            Present the alert controller
            present(ac, animated: true, completion: nil)
    }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        Update the model
        
        itemStore.moveItem(fromIndex: sourceIndexPath.row, to: destinationIndexPath.row)
        
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        if (proposedDestinationIndexPath.row >= itemStore.allItems.count){
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if (indexPath.row >= itemStore.allItems.count){
            return false
        }
        return true
    }
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if containsNoItem {
//            return nil
//        }
        return UISwipeActionsConfiguration(actions: [UIContextualAction(style: .normal, title: "Favorite") {
            [weak self] _,_,_ in
            let item: Item!
            item = self?.getItems()[indexPath.row]
            //item?.isFavorite = true
            item?.isFavorite = !item!.isFavorite
            if item.isFavorite {
                self!.itemStore.favItems.append(item)
            } else {
                if let itemToRemoveFromFav = self?.itemStore.favItems.firstIndex(of: item) {
                self?.itemStore.favItems.remove(at: itemToRemoveFromFav)
            }
            }
            print("Item \(item.name) is marked as favorite= \(item.isFavorite)")
            tableView.reloadRows(at: [indexPath], with: .automatic)
            }])
    }
    
//    func getItems() -> [Item]
//    {
//        return itemStore.allItems.filter { $0.isFavorite }
//    }

    func getItems() -> [Item]
    {
        if isFiltered {
        return itemStore.allItems.filter { $0.isFavorite }
        } else {
            return itemStore.allItems
        }
        
}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        If triggered segue is the "showItem" segue
        switch segue.identifier {
        case "showItem":
//            Figure out whic row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
//                Get the item associated with this row and pass it along
                let item = itemStore.allItems[row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.item = item
                detailViewController.imageStore = imageStore
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.leftBarButtonItem = editButtonItem
    }


}
