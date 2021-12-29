//
//  MainSelectedData.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/13.
//

import Foundation

struct isCherishDataChanged {
    static var shared = isCherishDataChanged()
    var status = false
    private init() {}
}
