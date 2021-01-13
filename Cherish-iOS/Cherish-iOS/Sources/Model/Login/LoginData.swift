//
//  LoginData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/11.
//

// MARK: - LoginData
struct LoginData: Codable {
    let userID: Int
    let userNickname: String

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case userNickname = "user_nickname"
    }
}
