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
}
