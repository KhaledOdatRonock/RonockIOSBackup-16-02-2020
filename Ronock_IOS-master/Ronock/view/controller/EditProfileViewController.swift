//
//  EditProfileViewController.swift
//  Ronock
//
//  Created by Khaled Odat on 12/5/19.
//  Copyright © 2019 Business Intelligence For Technology. All rights reserved.
//

import UIKit
import AppCenterAnalytics
import AppCenterCrashes

class EditProfileViewController: BaseViewController {

    let viewModel = EditProfileViewModel(repository: Repository.shared)

    let datePicker = UIDatePicker()
    
    @IBOutlet weak var profileImageLoading: UIActivityIndicatorView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var mobileNumber: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var dob: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        profileImageLoading.startAnimating()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
           profileImage.isUserInteractionEnabled = true
           profileImage.addGestureRecognizer(tapGestureRecognizer)
        
         viewModel.didFinishFetch = { profile in
            self.fullName.text = profile?.fullName
            self.mobileNumber.text = profile?.mobileNumber
            self.email.text = profile?.email
            self.profileImage.downloaded(from: profile?.imageURL ?? "")
        }
        
        viewModel.didProfileUpdated = {
            print("Profile updated success")
            self.navigationController?.popViewController(animated: true)
        }
        
        viewModel.didProfileImageUploaded = {
            print("Uploaded image")
            self.profileImageLoading.alpha = 0
        }
        
        viewModel.fetchProfile()

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        

        MSAnalytics.trackEvent(Constants.AppCenter.APP_CENTER_CATEGORY_PAGE_VIEW, withProperties: [Constants.AppCenter.APP_CENTER_EVENT_KEY_FRAGMENT_ENTERED: "EditProfileViewController"])
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date

            //ToolBar
           let toolbar = UIToolbar();
           toolbar.sizeToFit()

           //done button & cancel button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.datePickerValueChanged(sender:)))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPicker(sender:)))
           toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

        // add toolbar to textField
        dateTextField.inputAccessoryView = toolbar
         // add datepicker to textField
        dateTextField.inputView = datePicker
    }
    
    @IBAction func saveClicked(_ sender: Any) {
        let fullNameT = fullName.text
        let firstNameT = String(fullNameT?.split(separator: " ")[0] ?? "")
        let lastNameT = String(fullNameT?.split(separator: " ")[1] ?? "")
        
        let mobileNumberT = mobileNumber.text
        
        let profile = Profile(fullName: fullNameT, firstName: firstNameT, lastName: lastNameT, email: nil, mobileNumber: mobileNumberT, imageURL: nil)
        
        viewModel.sendProfileData(profile: profile)
    }
    
    @IBAction func datePickerClicked(_ sender: Any) {
         
        
    }
    
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateTextField.text = formatter.string(from: datePicker.date)
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    @objc func cancelPicker(sender: UIDatePicker){
        
    }
    

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerController.SourceType.photoLibrary;
            imag.allowsEditing = false
            self.present(imag, animated: true, completion: nil)
        }
    }
}

extension EditProfileViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profileImage.image = image
            self.profileImageLoading.alpha = 1
            viewModel.uploadProfileImage(image: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
