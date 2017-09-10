//
//  ResultsTests.swift
//  DiaryApp
//
//  Created by Ty Schenk on 9/9/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import XCTest
import CoreData

@testable import DiaryApp

class ManagedObjectTests: XCTestCase {
    
    func getNewInMemoryPersistentContainer() -> NSPersistentContainer {
        
        let container = NSPersistentContainer(name: "data")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        description.configuration = "Default"
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            XCTAssertNotNil(storeDescription, "Failed to create persistent container")
            XCTAssertNil(error, "Failed to create persistent container")
        })
        
        return container
    }
    
    var container: NSPersistentContainer?
    var managedObjectContext: NSManagedObjectContext?
    
    override func setUp() {
        super.setUp()
        
        container = getNewInMemoryPersistentContainer()
        managedObjectContext = container!.viewContext
        
        XCTAssertNotNil(managedObjectContext, "Failed to create managed object context for testing")
    }
    
    override func tearDown() {
        managedObjectContext = nil
        container = nil
        
        super.tearDown()
    }
    
    func testInsertDiaryEntryWithPasswordAndLocation() {
        let locationName = "Starbucks"
        let password = "1234"
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = "good"
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = false
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_noimage"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with password and location \(error)")
        }
    }
    
    func testInsertDiaryEntryWithLocation() {
        let locationName = "Starbucks"
        let password = ""
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = "good"
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = false
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_noimage"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with password and location \(error)")
        }
    }
    
    func testInsertBasicDiaryEntry() {
        let locationName = ""
        let password = ""
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = "good"
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = false
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_noimage"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with password and location \(error)")
        }
    }
    
    func testInsertDiaryEntryWithImage() {
        let locationName = ""
        let password = ""
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = "happy"
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = true
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_picture"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with Image \(error)")
        }
    }
    
    func testInsertDiaryEntryWithNoMoodAndImage() {
        let locationName = ""
        let password = ""
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = ""
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = true
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_picture"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with no mood and Image \(error)")
        }
    }
    
    func testInsertDiaryEntryWithNoContent() {
        let locationName = ""
        let password = ""
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = ""
        item.mood = ""
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = false
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_noimage"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with Image \(error)")
        }
    }
    
    func testInsertDiaryEntryWithFullContent() {
        let locationName = "Starbucks"
        let password = "1234"
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext!) as! Item
        
        item.content = "today i watched my cat do tricks"
        item.mood = "good"
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = true
        item.image = UIImageJPEGRepresentation(#imageLiteral(resourceName: "icn_picture"), 1.0)!
        
        if locationName != "" {
            item.location = locationName
        }
        
        if password != "" {
            item.password = password
            item.locked = true
        } else {
            item.password = ""
            item.locked = false
        }
        
        do {
            try managedObjectContext!.save()
            print("Correctly saved basic diary item object")
        } catch let error {
            XCTAssert(false, "Failed to save diary item object with Image \(error)")
        }
    }
}
