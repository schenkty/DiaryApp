//
//  Item+CoreDataProperties.swift
//  TodoList
//
//  Created by Ty Schenk on 8/29/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Item {

    @nonobjc open override class func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        return request as! NSFetchRequest<NSFetchRequestResult>
    }
    
    @NSManaged public var date: String
    @NSManaged public var content: String
    @NSManaged public var mood: String
    @NSManaged public var password: String
    @NSManaged public var locked: Bool
    @NSManaged public var location: String
    @NSManaged public var image: Data
    @NSManaged public var imageProvided: Bool
}
