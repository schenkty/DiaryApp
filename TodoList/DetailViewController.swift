//
//  DetailViewController.swift
//  TodoList
//
//  Created by Ty Schenk on 8/29/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import UIKit
import CoreData
import Lightbox
import ImagePicker
import LocationPicker

class DetailViewController: UIViewController, LightboxControllerPageDelegate, ImagePickerDelegate {
    
    var item: Item?
    var context: NSManagedObjectContext!
    let imagePickerController = ImagePickerController()
    let locationPicker = LocationPicker()
    var password: String = ""
    var beingUnlocked = false
    var beingLocked = false
    var mood: String = ""
    var locationName: String = ""
    var imageProvide = false
    
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var detailNavBar: UINavigationItem!
    @IBOutlet weak var passRemoveLabel: UILabel!
    @IBOutlet weak var lockButton: UIBarButtonItem!
    @IBOutlet weak var userImageButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        if let item = item {
            dateLabel.text = item.date
            passRemoveLabel.isHidden = true
            tempImage = UIImage(data: item.image)!
            mood = item.mood
            locationName = item.location
            imageProvide = item.imageProvided
            
            if item.locked == true {
                passwordView.isHidden = false
                password = item.password
                lockButton.image = #imageLiteral(resourceName: "lock_closed")
                lockButton.isEnabled = false
            } else {
                lockButton.image = #imageLiteral(resourceName: "lock_open")
                detailTextView.text = item.content
                lockButton.isEnabled = true
            }
        }

        userImageButton.setImage(tempImage, for: .normal)
        userImageButton.imageView?.layer.cornerRadius = 10
        userImageButton.imageView?.clipsToBounds = true
        if locationName != "" {
            locationLabel.text = locationName
        }
        
        // Image Picker Config
        imagePickerController.imageLimit = 1
    }
    
    @IBAction func passwordEnter(_ sender: UIButton) {
        if beingUnlocked == true {
            if passwordText.text == password {
                if let item = item {
                    item.locked = false
                    item.password = ""
                    password = ""
                }
                passwordText.text = ""
                passwordText.endEditing(true)
                passwordView.isHidden = true
                showAlert(title: "Password Removed!")
                lockButton.image = #imageLiteral(resourceName: "lock_open")
            } else {
                showAlert(title: "Wrong Password!")
            }
        }
        
        // Entry is unlocked
        if beingUnlocked == false && beingLocked == false {
            if passwordText.text == password {
                if let item = item {
                    detailTextView.text = item.content
                }
                passwordText.text = ""
                passwordText.endEditing(true)
                passwordView.isHidden = true
                lockButton.image = #imageLiteral(resourceName: "lock_closed")
                lockButton.isEnabled = true
            } else {
                showAlert(title: "Wrong Password!")
            }
        }
        
        if beingLocked == true {
            if let item = item {
                item.locked = true
                item.password = passwordText.text!
                password = passwordText.text!
            }
            passwordText.text = ""
            passwordText.endEditing(true)
            passwordView.isHidden = true
            showAlert(title: "Password Set!")
            lockButton.image = #imageLiteral(resourceName: "lock_closed")
        }
    }
    
    @IBAction func addLocationButton(_ sender: UIButton) {
        locationPicker.isForceReverseGeocoding = false
        locationPicker.pickCompletion = { (pickedLocationItem) in
            // Do something with the location the user picked.
            self.locationLabel.text = pickedLocationItem.name
            self.locationName = pickedLocationItem.name
        }
        navigationController!.pushViewController(locationPicker, animated: true)
    }
    
    
    @IBAction func unlockButton(_ sender: UIBarButtonItem) {
        guard let item = item else { return }
        
        if item.locked == true {
            beingUnlocked = true
            beingLocked = false
            passRemoveLabel.isHidden = false
        } else {
            beingUnlocked = false
            beingLocked = true
            passRemoveLabel.isHidden = true
        }
        
        if passwordView.isHidden == true {
            passwordView.isHidden = false
            detailTextView.endEditing(true)
        } else {
            passwordView.isHidden = true
            passwordText.endEditing(true)
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if let item = item, let newText = detailTextView.text {
            item.content = newText
            item.mood = mood
            item.imageProvided = imageProvide
            
            if tempImage != #imageLiteral(resourceName: "icn_noimage") {
                item.image = UIImageJPEGRepresentation(tempImage, 1.0)!
            }
            
            if locationName != "" {
                item.location = locationName
            }
            
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func imageButtonPressed(_ sender: UIButton) {
        if imageProvide {
            // Create an array of images.
            let images = [
                LightboxImage(image: tempImage)
            ]
            
            // Create an instance of LightboxController.
            let controller = LightboxController(images: images)
            
            // Set delegates.
            controller.pageDelegate = self
            
            // Use dynamic background.
            controller.dynamicBackground = true
            
            // Present your controller.
            present(controller, animated: true, completion: nil)
        } else {
            // Image Picker Setup
            imagePickerController.delegate = self
            present(imagePickerController, animated: true, completion: nil)
        }
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
    
    @IBAction func delteItem(_ sender: Any) {
        if let item = item {
            context.delete(item)
            context.saveChanges()
            navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(title: String, message: String? = nil, style: UIAlertControllerStyle = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    // Lightbox Delegate
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
    
    }
    
    // MARK: - Image Picker Delegate
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Image Picker: Wrapper Did Press")
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("Image Picker: Done Button Did Press")
        for image in images {
            tempImage = image
        }
        imageProvide = true
        let imageView: UIImageView = self.userImageButton.imageView!
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.userImageButton.setImage(tempImage, for: .normal)
        imagePicker.dismiss(animated: true)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        print("Image Picker: Cancel Button Did Press")
        imagePicker.dismiss(animated: true)
    }
}
