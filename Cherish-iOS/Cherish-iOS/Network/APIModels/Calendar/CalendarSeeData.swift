//
//  CalendarSeeData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/14.
//

import Foundation
// MARK: - CalendarSeeData
struct CalendarSeeData: Codable {
    let water: [Water]
    let futureWaterDate: String

    enum CodingKeys: String, CodingKey {
        case water
        case futureWaterDate = "future_water_date"
    }
}

// MARK: - Water
struct Water: Codable {
    let review, waterDate, keyword1, keyword2: String
    let keyword3: String

    enum CodingKeys: String, CodingKey {
        case review
        case waterDate = "water_date"
        case keyword1, keyword2, keyword3
    }
}
