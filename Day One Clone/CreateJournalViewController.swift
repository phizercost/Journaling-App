//
//  CreateJournalViewController.swift
//  Day One Clone
//
//  Created by Phizer Cost on 5/13/19.
//  Copyright © 2019 Phizer Cost. All rights reserved.
//

import UIKit
import RealmSwift


class CreateJournalViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var navbar: UINavigationBar!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var aboveNavBar: UIView!
    @IBOutlet weak var setDateButton: UIButton!
    var date = Date()
    var imagePicker = UIImagePickerController()
    var images : [UIImage] = []
    var startWithCamera = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        navbar.barTintColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00) // 4cc1fc
        navbar.tintColor = .white
        navbar.isTranslucent = false
        navbar .titleTextAttributes = [.foregroundColor : UIColor.white]
        aboveNavBar.backgroundColor = UIColor(red: 0.298, green: 0.757, blue: 0.988, alpha: 1.00)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(KeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        imagePicker.delegate = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        updateDate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if startWithCamera {
            startWithCamera = false
            blueCameraTapped("")
        }
    }
    
    func updateDate(){
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d, yyyy"
        navbar.topItem?.title = formatter.string(from: date)
    }
    @objc func KeyboardWillHide(notification:Notification){
        changeKeyboardHeight(notification: notification)
    }
    
    @objc func KeyboardWillShow(notification:Notification){
        changeKeyboardHeight(notification: notification)
    }
    
    func changeKeyboardHeight(notification:Notification){
        if let keyboardFrame =
            notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyHeight = keyboardFrame.cgRectValue.height
            bottomConstraint.constant = keyHeight + 10
            
        }
    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        if let realm = try? Realm() {
            let entry = Entry()
            entry.text = textView.text
            entry.date = date
            for image in images{
                let picture = Picture(image: image)
                entry.pictures.append(picture)
                picture.entry = entry
                
            }
            
            try? realm.write {
                realm.add(entry)
            }
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    @IBAction func blueCameraTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func calendarTapped(_ sender: Any) {
        textView.isHidden = true
        datePicker.isHidden = false
        setDateButton.isHidden = false
        datePicker.date = date
    }
    
    
    @IBAction func setDateTapped(_ sender: Any) {
        textView.isHidden = false
        datePicker.isHidden = true
        setDateButton.isHidden = true
        date = datePicker.date
        updateDate()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            images.append(chosenImage)
            //Animation
            let imageView = UIImageView()
            imageView.heightAnchor.constraint(equalToConstant: 70.0).isActive = true
            imageView.widthAnchor.constraint(equalToConstant: 70.0).isActive = true
            imageView.image = chosenImage
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            stackView.addArrangedSubview(imageView)
            
            imagePicker.dismiss(animated: true) {
                //Animation
            }
            
            
            
        }
    }
    
}
