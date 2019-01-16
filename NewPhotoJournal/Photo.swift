//
//  Photo.swift
//  NewPhotoJournal
//
//  Created by Leandro Wauters on 1/14/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

struct Photo: Codable {
    let createdAt: String
    let imageData: Data
    let description: String

    
    public var dateFormattedString: String {
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = createdAt
        if let date = isoDateFormatter.date(from: createdAt) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM d, yyyy hh:mm a"
            formattedDate = dateFormatter.string(from: date)
        }
        return formattedDate
    }
    public var date: Date{
        let isoDateFormatter = ISO8601DateFormatter()
        var formattedDate = Date()
        if let date = isoDateFormatter.date(from: createdAt) {
            formattedDate = date
        }
        return formattedDate
    }
}


