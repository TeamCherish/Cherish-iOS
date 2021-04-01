//
//  AboutCherishVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/31.
//

import UIKit

class AboutCherishVC: UIViewController {

    @IBOutlet weak var forScroll: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        setPhoneResoulution()
        // Do any additional setup after loading the view.
    }
    
    func setPhoneResoulution(){
        if UIDevice.current.isiPhoneSE2{
            forScroll.constant = 50
        }else if UIDevice.current.isiPhoneSE{
            forScroll.constant = 150
        }
    }
    
    //MARK: - add Swipe Guesture that go back to parentVC
    func addNavigationSwipeGuesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    @IBAction func icnBackAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
