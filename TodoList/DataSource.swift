//
//  DataSource.swift
//  TodoList
//
//  Created by Ty Schenk on 8/29/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit
import CoreData

class DataSource: NSObject, UITableViewDataSource {
    fileprivate let tableView: UITableView
    fileprivate let context: NSManagedObjectContext
    
    lazy var fetchedResultsController: TodoFetchedResultsController = {
        return TodoFetchedResultsController(managedObjectContext: self.context, tableView: self.tableView)
    }()
    
    init(tableView: UITableView, context: NSManagedObjectContext) {
        self.tableView = tableView
        self.context = context
    }
    
    func object(at indexPath: IndexPath) -> Item {
        return fetchedResultsController.object(at: indexPath)
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = fetchedResultsController.sections?[section] else { return 0 }
        
        if section.numberOfObjects == 0 {
            self.tableView.rowHeight = 100
        }
        
        return section.numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        
        return configureCell(cell as! EntryListCell, at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = fetchedResultsController.object(at: indexPath)
        context.delete(item)
        context.saveChanges()
    }
    
    fileprivate func configureCell(_ cell: EntryListCell, at indexPath: IndexPath) -> EntryListCell {
        let item = fetchedResultsController.object(at: indexPath)
        
        cell.dateLabel.text = item.date
        
        if item.imageProvided == true {
            cell.userImage.image = UIImage(data: item.image)
        } else {
            cell.userImage.image = #imageLiteral(resourceName: "icn_noimage")
        }
        
        let locationName = item.location
        
        // If user location for entry is set
        if locationName != "" {
            cell.locationLabel.text = item.location
            cell.locationLabel.isHidden = false
            cell.locationIcon.isHidden = false
        } else {
            cell.locationIcon.isHidden = true
            cell.locationLabel.isHidden = true
        }
        
        // If user mood is set
        switch item.mood {
        case "bad":
            cell.userMood.image = #imageLiteral(resourceName: "icn_bad")
        case "average":
            cell.userMood.image = #imageLiteral(resourceName: "icn_average")
        case "good":
            cell.userMood.image = #imageLiteral(resourceName: "icn_happy")
        default:
            cell.userMood.isHidden = true
        }
        
        // If Entry is locked
        if item.locked == true {
            cell.itemContentPreview.text = "This Entry is locked"
            cell.userMood.isHidden = true
            cell.locationIcon.isHidden = true
            cell.locationLabel.isHidden = true
            self.tableView.rowHeight = 110
        } else {
            cell.userMood.isHidden = false
            if locationName == "" {
                self.tableView.rowHeight = 160
            } else {
                self.tableView.rowHeight = 175
            }
            cell.itemContentPreview.text = item.content
        }
        
        return cell
    }
}
