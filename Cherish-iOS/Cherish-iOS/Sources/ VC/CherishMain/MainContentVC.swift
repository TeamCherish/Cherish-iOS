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
    @IBOutlet var progressbarView: ProgressBarView!
    @IBOutlet var flowerAnimationImageView: UIImageView!
    @IBOutlet var progressbarBackView: ProgressBarView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customProgressBarView()
        makeAnimation()
        NotificationCenter.default.addObserver(self, selector: #selector(changeBackgroundInfo), name: .cherishPeopleCellClicked, object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        customProgressBarView()
        
        // cherishPeopleCell이 선택되면 배경뷰의 라벨값, 식물이미지, 배경색을 바꿔준다.
        if appDel.isCherishPeopleCellSelected == true {
            self.userNickNameLabel.text = UserDefaults.standard.string(forKey: "selectedNickNameData")
        }
        
        // 식물상세페이지로 네비게이션 연결 후 탭바가 사라지기 때문에
        // popViewController 액션으로 다시 메인뷰로 돌아왔을 때 탭바가 나타나야 한다.
        self.tabBarController?.tabBar.isHidden = false
    }
    
    func makeAnimation() {
        self.flowerAnimationImageView.frame = CGRect(x: 112.33, y: 291.33, width: 56, height: 61.33)
        
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .autoreverse] , animations: {
                self.flowerAnimationImageView.frame = CGRect(x: 105, y: 290, width: 56, height: 61.33)
            }) { (completed) in
            }
    }
    
    
    //MARK: - 프로그레스바 커스텀
    func customProgressBarView() {
        progressbarBackView.setBackColor(color: .white)
        progressbarView.setBackColor(color: .white)
        progressbarView.setProgressColor(color: .seaweed)
        progressbarView.setProgressValue(currentValue: 73)
    }
    
    
    //MARK: - 식물 상세페이지 뷰로 이동
    @IBAction func moveToPlantDetailView(_ sender: UIButton) {
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "PlantDetail", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "PlantDetailVC") as? PlantDetailVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func moveToWateringPopUp(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "PopUpWatering", bundle: nil)
        if let vc = storyBoard.instantiateViewController(withIdentifier: "PopUpWateringVC") as? PopUpWateringVC{
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func moveToAlarmView(_ sender: UIButton) {
        let alarmVC = self.storyboard?.instantiateViewController(identifier: "AlarmVC") as! AlarmVC
        self.navigationController?.pushViewController(alarmVC, animated: true)
    }
    
    @objc func changeBackgroundInfo() {
        
        //noti 감지 후 view가 reload될 수 있도록 viewWillAppear함수를 호출해준다.
        viewWillAppear(true)
       
    }
}
