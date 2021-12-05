//
//  AboutCherishVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/31.
//

import UIKit

class AboutCherishVC: BaseController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func icnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func goToCherishInsta(_ sender: Any) {
        
        let instagramApp = "instagram://user?username=cherish_ofcl"
        let instagramWeb = "https://www.instagram.com/cherish_ofcl/"
        guard let instaAppURL = URL.init(string: instagramApp),
              let instaWebURL = URL.init(string: instagramWeb) else {
                  self.makeAlert(title: "단장중이에요! 다음에 다시 찾아주세요")
                  return
              }
        if UIApplication.shared.canOpenURL(instaAppURL as URL) {
            UIApplication.shared.open(instaAppURL as URL)
        } else {
            UIApplication.shared.open(instaWebURL as URL)
        }
    }
}
