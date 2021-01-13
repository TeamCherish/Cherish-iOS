//
//  AddUserData.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/13.
//

import Foundation

// MARK: - DataClass
struct AddUserData: Codable {
    let plant: Plant
}

// MARK: - Plant
struct Plant: Codable {
    let id: Int
    let name, explanation, modifier, flowerMeaning: String
    let thumbnailImageURL: String
    let plantStatusID: Int
    let imageURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, explanation, modifier
        case flowerMeaning = "flower_meaning"
        case thumbnailImageURL = "thumbnail_image_url"
        case plantStatusID = "PlantStatusId"
        case imageURL = "image_url"
    }
}
