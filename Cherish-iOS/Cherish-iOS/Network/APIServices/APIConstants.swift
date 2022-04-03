//
//  APIConstants.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2020/12/29.
//

import Foundation
struct APIConstants {
    static let baseURL = "http://3.39.63.248:8080/"
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
    static let signupURL = baseURL + "login/signup"
    static let checkSameEmailURL = baseURL + "checkSameEmail"
    static let messageAuthURL = baseURL + "login/phoneAuth"
    static let pushReviewURL = baseURL + "pushReview" ///pushReview
    static let fcmTokenUpdateURL = baseURL + "user/token" // 어플을 실행시킬때마다 바뀌는 fcm token을 업데이트 해주는 API
    static let deleteMobileTokenURL = baseURL + "push/token" // 로그아웃 시 mobile token을 삭제해주는 API
    static let addViewChangeNicknameURL = baseURL + "addView" // 더보기뷰 - 닉네임수정 API
    static let checkPhoneURL = baseURL + "cherish/checkPhone" // 이미 등록된 번호인지 확인하는 API
    static let findPasswordURL = baseURL + "login/findPassword" // 비밀번호 찾기-인증번호
    static let updatePasswordURL = baseURL + "login/updatePassword" // 비밀번호 찾기-새 비밀번호
    static let updateWateringPushURL = baseURL + "push" // 물줄 때마다 물주기 알림 정보를 업데이트 해주는 API
}
