//
//  MyPageSearchVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/18.
//

import UIKit

class MyPageSearchVC: UIViewController, UIGestureRecognizerDelegate {
    
    var changingIndex = false
    var mypagePlantCount: Int = 0
    var mypageContactCount: Int = 0
    
    let screenWidth = UIScreen.main.bounds.size.width
    
    @IBOutlet weak var segmentView: CustomSegmentedControl!  {
        didSet {
            // dispatch 차이!
//            DispatchQueue.main.async {
//
//                self.segmentView.setButtonTitles(buttonTitles: ["식물 \(self.mypagePlantCount)", "연락처 \(self.mypageContactCount)"])
//                self.segmentView.selectorViewColor = .black
//                self.segmentView.selectorTextColor = .black
//            }
//            var plantTitle = "식물 \(self.mypagePlantCount)"
//            var contactTitle = "연락처 \(self.mypageContactCount)"
//            let attributedPlantTitle = NSMutableAttributedString(string: plantTitle)
//            let attributedContactTitle = NSMutableAttributedString(string: contactTitle)
//            attributedPlantTitle.addAttribute(.foregroundColor, value: UIColor.textGrey, range: (plantTitle as NSString).range(of: "식물"))
//            attributedPlantTitle.addAttribute(.foregroundColor, value: UIColor.seaweed, range: (plantTitle as NSString).range(of: "\(self.mypagePlantCount)"))
//            attributedContactTitle.addAttribute(.foregroundColor, value: UIColor.textGrey, range: (plantTitle as NSString).range(of: "연락처"))
//            attributedContactTitle.addAttribute(.foregroundColor, value: UIColor.seaweed, range: (plantTitle as NSString).range(of: "\(self.mypageContactCount)"))
//            print("하이하이하이")
//            print(plantTitle)
//            print(attributedContactTitle.string)
//            print(attributedPlantTitle)
//            segmentView.setBtnTitles(buttonTitles: [attributedPlantTitle, attributedContactTitle])
            segmentView.setButtonTitles(buttonTitles: ["식물 \(self.mypagePlantCount)", "연락처 \(self.mypageContactCount)"])
            print("하이하이")
            print("식물 \(self.mypagePlantCount)")
            segmentView.selectorViewColor = .black
            segmentView.selectorTextColor = .black
            }
    }
    @IBOutlet weak var mySearchExternalSV: UIScrollView!
    @IBOutlet weak var myplantSearchSV: UIScrollView!
    @IBOutlet weak var myContactSearchSV: UIScrollView!
    
    var contactArray:[Friend] = []
    open var myPlantID: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("이동했당")
        setDelegates()
        getMypageData()
        makeCornerRadiusView(segmentView, 30)
    }

    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
    }
    
    func setDelegates() {
        mySearchExternalSV.delegate = self
        myplantSearchSV.delegate = self
        myContactSearchSV.delegate = self
        segmentView.delegate = self
    }
    
    func makeCornerRadiusView(_ view : UIView,_ radiusValue: Int){
        view.layer.cornerRadius = CGFloat(radiusValue)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func getMypageData() {
        let myPageUserIdx = UserDefaults.standard.integer(forKey: "userID")
        print(myPageUserIdx)
        let plantArr = UserDefaults.standard.array(forKey: "myCherishID")
    
        var contactArr : [Friend] = []
        
        if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
            contactArr = try! PropertyListDecoder().decode([Friend].self, from: data)
        }
        mypagePlantCount = plantArr!.count
        mypageContactCount = contactArr.count
        print("안녕")
        print(mypagePlantCount)
        segmentView.setButtonTitles(buttonTitles: ["식물 \(mypagePlantCount)", "연락처 \(mypageContactCount)"])
    }
    
    // MARK: - 취소버튼 누르면 마이페이지로 돌아가기
    @IBAction func popToMyPage(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension MyPageSearchVC: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        changingIndex = false
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == mySearchExternalSV {
            if !changingIndex{
                segmentView.setIndex(index: Int(round(mySearchExternalSV.contentOffset.x / mySearchExternalSV.frame.size.width)))
            }
            
            // horizontal scroll 시
            // 스크롤 영역보다 왼쪽으로 (0미만값으로) 스크롤 될 때
            if scrollView.contentOffset.x < 0 {
                // contentOffset.x 값을 왼쪽 최소값인 0으로 설정
                scrollView.contentOffset.x = 0
            }
            // 스크롤 영역보다 오른쪽으로 (375초과값으로) 스크롤 될 때
            else if scrollView.contentOffset.x > screenWidth {
                // contentOffset.x 값을 오른쪽 최대값인 375로 설정
                /// 이부분은 기기사이즈에 따라 달라지므로 autolayout 다시 살펴봐야함!
                scrollView.contentOffset.x = screenWidth
            }
        }
    }
}

extension MyPageSearchVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        changingIndex = true
        let x = segmentView.selectedIndex * Int(mySearchExternalSV.frame.width)
        mySearchExternalSV.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
        print(mySearchExternalSV.contentInset.left)
        
    }
    
}

