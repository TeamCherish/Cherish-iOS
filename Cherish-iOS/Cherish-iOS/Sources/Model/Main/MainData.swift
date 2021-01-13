//
//  MainData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/11.
//

import Foundation

struct MainData: Codable {
    let result: [ResultData]
    let totalCherish: Int
}

// MARK: - Result
struct ResultData: Codable{
    let id, dDay: Int
    let nickname, phone: String
    let growth: Int
    let thumbnailImageURL, modifier: String

    enum CodingKeys: String, CodingKey {
        case id, dDay, nickname, phone, growth
        case thumbnailImageURL = "thumbnail_image_url"
        case modifier
    }
}
