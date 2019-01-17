//
//  AddItemViewController.swift
//  NewPhotoJournal
//
//  Created by Leandro Wauters on 1/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    
    var function: Function!
    var imageSelected = UIImage()
    var indexSelected = Int()
    var imageWasSelected = Bool()
    private var imagePickerViewController: UIImagePickerController!
    
    @IBOutlet weak var imageDescriptionTextView: UITextView!
    
    @IBOutlet weak var imageToAdd: UIImageView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var photoLibraryButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showSaveButton()
        saveButton.isEnabled = false
        imageDescriptionTextView.delegate = self
        imageDescriptionTextView.text = "Enter Title"
        imageDescriptionTextView.textColor = .lightGray
        if function == .edit{
            saveButton.isEnabled = false
            cameraButton.isEnabled = false
            photoLibraryButton.isEnabled = false
            imageToAdd.image = imageSelected
        }
        setupImagePickerViewController()
    }
    
    private func setupImagePickerViewController(){
        imagePickerViewController = UIImagePickerController()
        imagePickerViewController.delegate = self
        if !UIImagePickerController.isSourceTypeAvailable(.camera){
            cameraButton.isEnabled = false
        }
    }
    private func showImagePickerController() {
        present(imagePickerViewController,animated: true,completion:  nil)
    }
    private func showSaveButton(){
        if imageDescriptionTextView.text != nil{
            if imageWasSelected || function == .edit{
                saveButton.isEnabled = true
            }
        }
    }
    @IBAction func savedWasPressed(_ sender: UIBarButtonItem) {
        guard let photoDescription = imageDescriptionTextView.text else {fatalError("title nil")}
        if let imageData = imageSelected.jpegData(compressionQuality: 0.5) {
        let date = Date()
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withFullDate, .withFullTime, .withTimeZone, .withInternetDateTime, .withDashSeparatorInDate]
        let timestamp = isoDateFormatter.string(from: date)
        let photo = Photo.init(createdAt: timestamp, imageData: imageData, description: photoDescription)
            if function == .add{
                PhotoModel.addPhoto(photo: photo)
            }
            if function == .edit{
                PhotoModel.edit(item: photo, atIndex: indexSelected)
            }
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func photoLibraryPressed(_ sender: UIBarButtonItem) {
        showImagePickerController()
        imagePickerViewController.sourceType = .photoLibrary
    }
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        imagePickerViewController.sourceType = .camera
        showImagePickerController()
    }
    
    @IBAction func cancelWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
extension AddItemViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate,UITextViewDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageToAdd.image = image
            imageSelected = image
            imageWasSelected = true
            showSaveButton()
//            savePhotoJournal(image: image)
        } else {
            print("Originial image is nil")
        }
        dismiss(animated: true, completion: nil)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
//        saveButton.isEnabled = true
        textView.text = ""
        textView.textColor = .black
        showSaveButton()
    }
}
