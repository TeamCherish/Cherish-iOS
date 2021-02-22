//
//  APIConstants.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import Foundation
struct APIConstants {
    static let baseURL = "http://cherishserver.com/"
    static let wateringReviewURL = baseURL + "water" /// 물주기[연락후기]
    static let wateringDayURL = baseURL + "search/" /// 물주는 날짜 조회
    static let laterURL = baseURL + "postpone" /// 미루기
    static let laterCheckURL = baseURL + "postpone?CherishId=" /// 미루기 3회 미만인지 Check
    static let recentKeywordURL = baseURL + "contact/" // 최근 연락 키워드
    static let loginURL = baseURL + "login/signin"
    static let mainURL = baseURL + "cherish/" ///체리쉬 메인
    static let addURL = baseURL + "cherish" /// 식물등록, 식물 수정
    static let plantDetailURL = baseURL + "cherish?CherishId="
    static let plantDetailCardURL = baseURL + "plantDetail/"
    static let calendarURL = baseURL + "calendar/"
    static let mypageURL = baseURL + "user/" ///마이페이지
    static let getPlantDataURL = baseURL + "getCherishDetail/" /// 식물 수정할 때 정보 받아오기
    static let deletePlantURL = baseURL + "cherish/"
}
