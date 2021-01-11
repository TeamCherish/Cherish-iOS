//
//  APIConstants.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import Foundation
struct APIConstants {
    static let baseURL = "http://3.35.117.232:8080/"
    static let LoginURL = baseURL + "login/signin"
    static let wateringReviewURL = baseURL + "water" /// 물주기[연락후기]
    static let wateringDayURL = baseURL + "search" /// 물주는 날짜 조회
    static let laterURL = baseURL + "postpone" /// 미루기
    static let laterCheckURL = baseURL + "postpone?CherishId=" /// 미루기 3회 미만인지 Check
}
