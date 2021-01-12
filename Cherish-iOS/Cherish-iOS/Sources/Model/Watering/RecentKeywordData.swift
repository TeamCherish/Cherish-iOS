//
//  RecentKeywordData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/12.
//

// MARK: - RecentKeywordData
struct RecentKeywordData: Codable {
    let nickname: String
    let water: Water
}

// MARK: - Water
struct Water: Codable {
    let id: Int
    let waterDate, keyword1, keyword2, keyword3: String

    enum CodingKeys: String, CodingKey {
        case id
        case waterDate = "water_date"
        case keyword1, keyword2, keyword3
    }
}
