//
//  PhotosModel.swift
//  NewPhotoJournal
//
//  Created by Leandro Wauters on 1/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

final class PhotoModel {
    private static var photos = [Photo]()
    private static let filename = "PhotoList.plist"
    private init () {}
    
//    static func savePhotoJournal(photoJournal: Photo) {
//        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: filename)
//        do {
//            let data = try PropertyListEncoder().encode(photoJournal)
//            try data.write(to: path, options: .atomic)
//        }catch {
//            print("property list encoding error \(error)")
//        }
//    }
    static func addPhoto(photo: Photo){
        photos.append(photo)
        save()
    }
    static func save(){
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: filename)
        do {
            let data = try PropertyListEncoder().encode(photos)
            try data.write(to: path, options: .atomic)
        } catch {
            print("Property list encoding error \(error)")
        }
    }
    static func delete(item: Photo, atIndex index: Int){
        photos.remove(at: index)
        save()
    }
    static func edit(item: Photo, atIndex index: Int) {
        photos.remove(at: index)
        photos.insert(item, at: index)
        save()
    }
    static func getPhotos() -> [Photo]{
        
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path){
            if let data = FileManager.default.contents(atPath: path){
                do {
                    photos = try PropertyListDecoder().decode([Photo].self, from: data)
                }catch{
                    print("Property list decoding error: \(error)")
                }
            } else {
                print("getPhotoJournal data is nil")
            }
        } else {
            print("\(filename) does not exist")
        }
        return photos
    }
}
