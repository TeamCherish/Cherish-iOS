//
//  SignUpData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/17.
//

import Foundation

// MARK: - SignUpData
struct SignUpData: Codable {
    let success: Bool
    let message: String
    let data: DataClass
}

// MARK: - DataClass
struct DataClass: Codable {
    let nickname: String
}
