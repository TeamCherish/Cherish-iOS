//
//  MainContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class MainContentVC: UIViewController {

    @IBOutlet var dayCountLabel: UILabel!
    @IBOutlet var plantExplainLabel: CustomLabel!
    @IBOutlet var userNickNameLabel: CustomLabel!
    @IBOutlet var plantImageView: UIImageView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundInfo), name: .cherishPeopleCellClicked, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true {
            self.userNickNameLabel.text = UserDefaults.standard.string(forKey: "selectedNickNameData")
        }
    }
    
    
    //MARK: - 식물 상세페이지 뷰로 이동
    @IBAction func moveToPlantDetailView(_ sender: UIButton) {
    }
    
    @objc func changeBackgroundInfo(){
        
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        viewWillAppear(true)
       
    }
}
