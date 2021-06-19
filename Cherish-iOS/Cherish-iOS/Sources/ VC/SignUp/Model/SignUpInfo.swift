//
//  SignUpInfo.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/06/07.
//

import Foundation

class SignUpInfo {
    static let shared = SignUpInfo()
    var email: String?
    var password: String?
    var phone: String?
    var nickName: String?
    private init() { }
}
