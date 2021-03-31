//
//  AboutCherishVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/31.
//

import UIKit

class AboutCherishVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        self.tabBarController?.tabBar.isHidden = false
    }
    //MARK: - add Swipe Guesture that go back to parentVC
    func addNavigationSwipeGuesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    @IBAction func icnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
