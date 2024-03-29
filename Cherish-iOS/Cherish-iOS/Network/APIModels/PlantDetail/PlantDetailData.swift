//
//  PlantDetailData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/12.
//

import Foundation

struct PlantDetailData: Codable {
    let name, nickname, birth: String
    let duration, dDay, plantId: Int
    let plantName, plantThumbnailImageURL, statusMessage, status: String
    let gage: Float
    let reviews: [Review]
    let keyword1, keyword2, keyword3: String

    enum CodingKeys: String, CodingKey {
        case name, nickname, birth, duration, dDay, plantId, status
        case plantName = "plant_name"
        case plantThumbnailImageURL = "plant_thumbnail_image_url"
        case statusMessage = "status_message"
        case gage, reviews, keyword1, keyword2, keyword3
    }
}

// MARK: - Review
struct Review: Codable {
    let waterDate, review: String

    enum CodingKeys: String, CodingKey {
        case waterDate = "water_date"
        case review
    }
}
