//
//  MypageData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/14.
//

import Foundation

// MARK: - MypageData
struct MypageData: Codable {
    let userNickname: String
    let postponeCount, totalCherish, waterCount, completeCount: Int
    let result: [MypagefriendsData]

    enum CodingKeys: String, CodingKey {
        case userNickname = "user_nickname"
        case postponeCount, totalCherish, waterCount, completeCount, result
    }
}

// MARK: - Result
struct MypagefriendsData: Codable {
    let id, dDay: Int
    let nickname, name: String
    let thumbnailImageURL: String
    let level, plantID: Int

    enum CodingKeys: String, CodingKey {
        case id, dDay, nickname, name
        case thumbnailImageURL = "thumbnail_image_url"
        case level
        case plantID = "PlantId"
    }
}
