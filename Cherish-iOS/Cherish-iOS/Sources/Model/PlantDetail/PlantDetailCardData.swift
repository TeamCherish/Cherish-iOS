//
//  PlantDetailCardData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/13.
//

import Foundation

// MARK: - PlantDetailCardData
struct PlantDetailCardData: Codable {
    let plantResult: PlantCardResult
    let plantDetail: [PlantCard]
}

// MARK: - PlantCard
struct PlantCard: Codable {
    let levelName, plantDetailDescription, imageURL: String

    enum CodingKeys: String, CodingKey {
        case levelName = "level_name"
        case plantDetailDescription = "description"
        case imageURL = "image_url"
    }
}

// MARK: - PlantResult
struct PlantCardResult: Codable {
    let modifier, flowerMeaning, explanation: String

    enum CodingKeys: String, CodingKey {
        case modifier
        case flowerMeaning = "flower_meaning"
        case explanation
    }
}
