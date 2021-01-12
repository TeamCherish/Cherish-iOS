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
    let plantName, plantThumbnailImageURL, statusMessage: String
    let gage: Int
    let review: [Review]
    let keyword1, keyword2, keyword3: String


    enum CodingKeys: String, CodingKey {
        case name, nickname, birth, duration, dDay
        case plantName = "plant_name"
        case plantThumbnailImageURL = "plant_thumbnail_image_url"
        case statusMessage = "status_message"
        case gage, review, keyword1, keyword2, keyword3
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
