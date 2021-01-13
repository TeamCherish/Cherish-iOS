//
//  RecentKeywordData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/12.
//

// MARK: - RecentKeywordData
struct RecentKeywordData: Codable {
    let nickname: String
    let result: Result
}

// MARK: - Result
struct Result: Codable {
    let keyword1, keyword2, keyword3, waterDate: String

    enum CodingKeys: String, CodingKey {
        case keyword1, keyword2, keyword3
        case waterDate = "water_date"
    }
}
