//
//  PlantDetailCardData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/13.
//

import Foundation

// MARK: - DataClass
struct PlantDetailCardData: Codable {
    let plantResult: PlantResult
    let plantDetail: [PlantCard]
}

// MARK: - PlantDetail
struct PlantCard: Codable {
    let levelName, plantDetailDescription, imageURL: String

    enum CodingKeys: String, CodingKey {
        case levelName = "level_name"
        case plantDetailDescription = "description"
        case imageURL = "image_url"
    }
}

// MARK: - PlantResult
struct PlantResult: Codable {
    let modifier, flowerMeaning, explanation: String

    enum CodingKeys: String, CodingKey {
        case modifier
        case flowerMeaning = "flower_meaning"
        case explanation
    }
}
