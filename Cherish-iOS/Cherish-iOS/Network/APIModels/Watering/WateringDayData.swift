//
//  WateringDayData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/11.
//

// MARK: - WateringDayData
struct WateringDayData: Codable {
    let waterDate: String

    enum CodingKeys: String, CodingKey {
        case waterDate = "WaterDate"
    }
}

