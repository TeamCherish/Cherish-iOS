//
//  OnboardingData.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/30.
//

import Foundation

struct Onboarding {
    let onboardingImageName : String
    let titleLabelName: String
    let descriptionLabelName: String
}

let onboardingData: [Onboarding] = [
    Onboarding(onboardingImageName: "imgOnboarding1", titleLabelName: "식물을 키워요!", descriptionLabelName: "자꾸 미루는 연락, \n 식물 키우기 게임처럼 즐겨봐요"),
    Onboarding(onboardingImageName: "imgOnboarding2", titleLabelName: "식물을 추천해요", descriptionLabelName: "설정한 연락주기와 비슷한 물주기를 가진 식물이 \n 매칭돼요."),
    Onboarding(onboardingImageName: "imgOnboarding3", titleLabelName: "알림을 받아요!", descriptionLabelName: "주기가 다가올 때마다 '연락하기' 알람을 받아요."),
    Onboarding(onboardingImageName: "imgOnboarding4", titleLabelName: "연락을 기록해요!", descriptionLabelName: "오늘의 연락을 키워드와 메모로 기록해요."),
]
