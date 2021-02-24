//
//  MypageData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/14.
//

import Foundation

// MARK: - MypageData
struct MypageData: Codable {
    let userNickname, email: String
    let postponeCount, totalCherish, waterCount, completeCount: Int
    let result: [MypagefriendsData]
    
    enum CodingKeys: String, CodingKey {
        case userNickname = "user_nickname"
        case postponeCount, totalCherish, waterCount, completeCount, result, email
    }
}

// MARK: - Result
struct MypagefriendsData: Codable {
    let id, dDay: Int
    let nickname, name, email: String
    let thumbnailImageURL: String
    let level: Int?
    let plantID: Int
    
    enum CodingKeys: String, CodingKey {
        case id, dDay, nickname, name, email
        case thumbnailImageURL = "thumbnail_image_url"
        case level
        case plantID = "PlantId"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = (try? values.decode(Int.self, forKey: .id)) ?? -1
        dDay = (try? values.decode(Int.self, forKey: .dDay)) ?? -1
        nickname = (try? values.decode(String.self, forKey: .nickname)) ?? ""
        name = (try? values.decode(String.self, forKey: .name)) ?? ""
        email = (try? values.decode(String.self, forKey: .email)) ?? ""
        thumbnailImageURL = (try? values.decode(String.self, forKey: .thumbnailImageURL)) ?? ""
        level = (try? values.decode(Int.self, forKey: .level)) ?? -1
        plantID = (try? values.decode(Int.self, forKey: .plantID)) ?? -1
    }

}
