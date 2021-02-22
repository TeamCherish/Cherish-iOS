//
//  GetPlantData.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/19.
//

import Foundation

// MARK: - DataClass
struct GetPlantData: Codable {
    let cherishDetail: CherishDetail
}

// MARK: - CherishDetail
struct CherishDetail: Codable {
    let nickname, birth, phone: String
    let cycleDate: Int
    let noticeTime: String
    let waterNotice: Bool

    enum CodingKeys: String, CodingKey {
        case nickname, birth, phone
        case cycleDate = "cycle_date"
        case noticeTime = "notice_time"
        case waterNotice = "water_notice"
    }
}
