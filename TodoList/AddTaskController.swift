//
//  AddTaskController.swift
//  TodoList
//
//  Created by Ty Schenk on 8/29/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit
import CoreData
import MapKit
import ImagePicker
import LocationPicker

class AddTaskController: UIViewController, ImagePickerDelegate {
    
    var managedObjectContext: NSManagedObjectContext!
    let locationPicker = LocationPicker()
    let imagePickerController = ImagePickerController()
    var password: String = ""
    var mood: String = ""
    var locationName: String = ""
    var imageProvide = false
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var lockButton: UIBarButtonItem!
    @IBOutlet weak var addNavBar: UINavigationItem!
    @IBOutlet var hideButtonsDuringPassword: [UIButton]!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var addLocationButton: UIButton!
    @IBOutlet weak var addLocationLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.placeholder = "What happened today?"
        dateLabel.text = getCurrentDate(format: .dateMonth)
        self.automaticallyAdjustsScrollViewInsets = false
        tempImage = #imageLiteral(resourceName: "icn_noimage")
        
        // Image Picker Config
        imagePickerController.imageLimit = 1
    }
    
    @IBAction func lockButton(_ sender: UIBarButtonItem) {
        if passwordView.isHidden == true {
            hideDuringPassword(on: true)
            passwordView.isHidden = false
            textView.endEditing(true)
        } else {
            hideDuringPassword(on: false)
            passwordView.isHidden = true
            passwordText.endEditing(true)
        }
    }
    
    @IBAction func passwordEnterButton(_ sender: Any) {
        guard let passText = passwordText.text else { return }
        if passText != "" {
            password = passText
            passwordView.isHidden = true
            hideDuringPassword(on: false)
            lockButton.image = #imageLiteral(resourceName: "lock_closed")
            showAlert(title: "Password Set")
            passwordText.endEditing(true)
        } else {
            showAlert(title: "Password Field Empty")
        }
    }
    
    @IBAction func addLocation(_ sender: UIButton) {
        locationPicker.isForceReverseGeocoding = false
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
            self.addLocationLabel.text = pickedLocationItem.name
            self.locationName = pickedLocationItem.name
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    @IBAction func addImage(_ sender: UIButton) {
        // Image Picker Setup
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func badMood(_ sender: UIButton) {
        mood = "bad"
        showAlert(title: "Mood Set!")
    }
    
    @IBAction func averageMood(_ sender: UIButton) {
        mood = "average"
        showAlert(title: "Mood Set!")
    }
    
    @IBAction func goodMood(_ sender: UIButton) {
        mood = "good"
        showAlert(title: "Mood Set!")
    }
    
    @IBAction func save(_ sender: Any) {
        guard let content = textView.text else { return }
        
        let item = NSEntityDescription.insertNewObject(forEntityName: "Item", into: managedObjectContext) as! Item
        item.content = content
        item.mood = mood
        item.date = getCurrentDate(format: .dateMonth)
        item.imageProvided = imageProvide
        item.image = UIImageJPEGRepresentation(tempImage, 1.0)!
        
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
        
        managedObjectContext.saveChanges()
        dismiss(animated: true, completion: nil)
    }
    
    func hideDuringPassword(on: Bool) {
        dateLabel.isHidden = on
        textView.isHidden = on
        for item in hideButtonsDuringPassword {
            item.isHidden = on
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        tempImage = #imageLiteral(resourceName: "icn_noimage")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Image Picker Delegate
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Image Picker: Wrapper Did Press")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Image Picker: Done Button Did Press")
        for image in images {
            tempImage = image
            imageProvide = true
        }
        let imageView: UIImageView = self.addImageButton.imageView!
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.addImageButton.setImage(tempImage, for: .normal)
        imagePicker.dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("Image Picker: Cancel Button Did Press")
        imagePicker.dismiss(animated: true)
    }

    // MARK: - Show Alert function
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
