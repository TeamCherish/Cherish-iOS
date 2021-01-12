//
//  PlantDetailData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/12.
//

import Foundation

struct PlantDetailData: Codable {
    let name, nickname, birth: String
    let duration, dDay: Int
    let plantName, plantThumbnailImageURL: String
    let statusMessage: StatusMessage
    let keyword1, keyword2, keyword3: String
    let reviews: [Review]
    
    enum CodingKeys: String, CodingKey {
        case name, nickname, birth, duration, dDay
        case plantName = "plant_name"
        case plantThumbnailImageURL = "plant_thumbnail_image_url"
        case statusMessage = "status_message"
        case keyword1, keyword2, keyword3, reviews
    }
}

// MARK: - Review
struct Review: Codable {
    let id: Int
    let review: String?
    let waterDate, keyword1: String
    let keyword2, keyword3: String?
    
    enum CodingKeys: String, CodingKey {
        case id, review
        case waterDate = "water_date"
        case keyword1, keyword2, keyword3
    }
}

// MARK: - StatusMessage
struct StatusMessage: Codable {
    let message: String
}
