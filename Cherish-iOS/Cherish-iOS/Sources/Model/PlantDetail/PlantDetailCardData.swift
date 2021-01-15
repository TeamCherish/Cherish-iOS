//
//  PlantDetailCardData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/13.
//

import Foundation

// MARK: - PlantDetailCardData
struct PlantDetailCardData: Codable {
    let plantResponse: [PlantResponse]
    let plantDetail: [PlantDetail]
}

// MARK: - PlantDetail
struct PlantDetail: Codable {
    let levelName, plantDetailDescription: String
    let imageURL, image: String

    enum CodingKeys: String, CodingKey {
        case levelName = "level_name"
        case plantDetailDescription = "description"
        case imageURL = "image_url"
        case image
    }
}

// MARK: - PlantResponse
struct PlantResponse: Codable {
    let modifier, explanation, flowerMeaning: String
    let image, imageURL: String

    enum CodingKeys: String, CodingKey {
        case modifier, explanation
        case flowerMeaning = "flower_meaning"
        case image
        case imageURL = "image_url"
    }
}

