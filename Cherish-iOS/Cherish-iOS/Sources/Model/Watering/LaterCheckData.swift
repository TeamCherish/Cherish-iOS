//
//  LaterCheckData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/11.
//

// MARK: - LaterCheckData
struct LaterCheckData: Codable {
    let cherish: Cherish
    let isLimitPostponeNumber: Bool

    enum CodingKeys: String, CodingKey {
        case cherish
        case isLimitPostponeNumber = "is_limit_postpone_number"
    }
}

// MARK: - Cherish
struct Cherish: Codable {
    let waterDate: String
    let postponeNumber: Int

    enum CodingKeys: String, CodingKey {
        case waterDate = "water_date"
        case postponeNumber = "postpone_number"
    }
}

