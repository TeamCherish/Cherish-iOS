//
//  MessageAuthData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/02/20.
//

import Foundation

// MARK: - Welcome
struct MessageAuthData: Codable {
    var status: Int
    var success: Bool
    var message: String
    var data: Int

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case success = "success"
        case message = "message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = (try? values.decode(Int.self, forKey: .status)) ?? -1
        success = (try? values.decode(Bool.self, forKey: .success)) ?? false
        message = (try? values.decode(String.self, forKey: .message)) ?? ""
        data = (try? values.decode(Int.self, forKey: .data)) ?? -1
    }
}

