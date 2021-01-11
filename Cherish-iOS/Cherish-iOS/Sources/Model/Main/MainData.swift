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
struct ResultData: Codable {
    let id: Int
    let dDay: Int?
    let nickname: String?
    let growth: Int?
    let thumbnailImageURL: String?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, dDay, nickname, growth
        case thumbnailImageURL,imageURL
    }
}
