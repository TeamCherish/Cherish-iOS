//
//  MyPageSearchContactVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class MyPageSearchContactVC: UIViewController {
    
    var myCherishContact: [Friend] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // Userdefaults에 저장된 contact 가져오기
//    if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
//        let contacts = try? PropertyListDecoder().decode([Friend].self, from: data)
//
//        contactArray = contacts!
//    }
//    mypageContactCount = contactArray.count
//    segmentView.setButtonTitles(buttonTitles: ["식물 \(mypagePlantCount)", "연락처 \(mypageContactCount)"])
    
}
