//
//  ViewController.swift
//  NewPhotoJournal
//
//  Created by Leandro Wauters on 1/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class PhotoJournalViewController: UIViewController {

    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var photos = PhotoModel.getPhotos()

    override func viewDidLoad() {
        super.viewDidLoad()
        reload()
        photoCollectionView.dataSource = self
        photoCollectionView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }
    @IBAction func addWasPressed(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: "AddPhotos") as? AddItemViewController else {return}
        vc.function = .add
        present(vc, animated: true, completion: nil)
        
    }
    func reload(){
        photos = PhotoModel.getPhotos()
        photoCollectionView.reloadData()
    }
 
    override func viewWillAppear(_ animated: Bool) {
        photoCollectionView.reloadData()
        photos = PhotoModel.getPhotos()
    }
    @objc func popAlert (sender: UIButton){
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let index = sender.tag
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (UIAlertAction) in
            PhotoModel.delete(item: self.photos[index], atIndex: index)
            self.reload()
            
            
        }
        let edit = UIAlertAction(title: "Edit", style: .default) { (UIAlertAction) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "AddPhotos") as? AddItemViewController else {return}
            vc.function = .edit
            if let image = UIImage(data: self.photos[index].imageData){
            vc.imageSelected = image
            vc.indexSelected = index
            }
            self.present(vc, animated: true, completion: nil)
        }
        let share = UIAlertAction(title: "Share", style: .default) { (UIAlertAction) in
            var photo = [UIImage()]
            if let image = UIImage(data: self.photos[index].imageData){
            photo = [image]
            }
            let ac = UIActivityViewController(activityItems: photo, applicationActivities: nil)
            self.present(ac, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        actionSheet.addAction(delete)
        actionSheet.addAction(edit)
        actionSheet.addAction(share)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }

}
extension PhotoJournalViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoCell", for: indexPath) as? ImageCollectionViewCell else {return UICollectionViewCell()}
        let photoToSet = photos[indexPath.row]
        cell.descriptionLabel.text = photoToSet.description
        cell.dateLabel.text = photoToSet.dateFormattedString
        cell.cellButton.tag = indexPath.row
        cell.cellButton.addTarget(self, action: #selector(popAlert(sender:)), for: .touchUpInside)
        let image = UIImage(data: photoToSet.imageData)
        cell.image.image = image
        cell.layer.cornerRadius = 15
        cell.layer.borderWidth = 5
        cell.layer.borderColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor
//        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
         return CGSize.init(width:350, height:500)
        
    }
    
}
