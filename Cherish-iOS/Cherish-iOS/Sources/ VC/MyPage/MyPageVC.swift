//
//  MyPageVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class MyPageVC: UIViewController, UIGestureRecognizerDelegate {
    
    var changingIndex = false
    var mypagePlantCount: Int = 0
    var mypageContactCount: Int = 0
    
    
    @IBOutlet var mypageUserImageView: UIImageView!
    @IBOutlet var mypageNaviView: UIView!
    @IBOutlet var mypageHeaderView: PassthroughView!
    @IBOutlet var stickyHeaderView: UIView!
    @IBOutlet var userNicknameLabel: UILabel!
    @IBOutlet var userWateringCountLabel: CustomLabel!
    @IBOutlet var userWateringPostponeCountLabel: CustomLabel!
    @IBOutlet var userGrowCompleteCountLabel: CustomLabel!
    @IBOutlet var segmentView: CustomSegmentedControl! {
        didSet {
            segmentView.setButtonTitles(buttonTitles: ["식물 \(mypagePlantCount)", "연락처 \(mypageContactCount)"])
            segmentView.selectorViewColor = .black
            segmentView.selectorTextColor = .black
        }
    }
    @IBOutlet var headerTopConstraint: NSLayoutConstraint!
    @IBOutlet var headerHeightConstraint: NSLayoutConstraint!
    @IBOutlet var mypageExternalSV: UIScrollView!
    @IBOutlet var plantSV: UIScrollView!
    @IBOutlet var plantSVWidth: NSLayoutConstraint!
    @IBOutlet var contactSV: UIScrollView!
    @IBOutlet var plantContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet var contactContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet var addFloatingBtn: UIButton!
    
    var contactArray:[Friend] = []
    
    // 식물 아이디 배열
    open var myPlantID: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeStatusBarBackgroundColor("mypageBackground")
        setImageViewRounded()
        getMypageData()
        setDelegates()
        setConstraints()
        makeCornerRadiusView(segmentView, 30)
        makeCornerRadiusView(stickyHeaderView, 30)
        addFloatingBtn.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LoadingHUD.show()
        getMypageData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        LoadingHUD.hide()
    }
    
    func setDelegates() {
        mypageExternalSV.delegate = self
        plantSV.delegate = self
        contactSV.delegate = self
        segmentView.delegate = self
    }
    
    func setConstraints() {
        plantSVWidth.constant = self.view.frame.width
        plantContainerTopConstraint.constant = mypageHeaderView.frame.height
        contactContainerTopConstraint.constant = mypageHeaderView.frame.height
        stickyHeaderView.isExclusiveTouch = true
    }
    
    //MARK: - 상태바 백그라운드 컬러 변경
    func changeStatusBarBackgroundColor(_ Color : String) {
        let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
        let statusBarColor = UIColor(named: Color)
        statusBarView.backgroundColor = statusBarColor
        view.addSubview(statusBarView)
    }
    
    //MARK: - 프로필 이미지 뷰 round 처리
    func setImageViewRounded() {
        mypageUserImageView.clipsToBounds = true
        mypageUserImageView.layer.cornerRadius = mypageUserImageView.frame.height / 2
    }
    
    func makeCornerRadiusView(_ view : UIView,_ radiusValue: Int){
        view.layer.cornerRadius = CGFloat(radiusValue)
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setFloatingBtnOffset(_ floatingBtn: UIButton ,_ isHidden: Bool,_ x: CGFloat,_ y: CGFloat,_ width: CGFloat,_ height: CGFloat) {
        floatingBtn.isHidden = isHidden
        floatingBtn.frame = CGRect(x: x, y: y, width: width, height: height)
    }
    
    //MARK: - 마이페이지 식물 데이터 구성하는 함수
    func getMypageData() {
        let myPageUserIdx = UserDefaults.standard.integer(forKey: "userID")
        print(myPageUserIdx)
        MypageService.shared.inquireMypageView(idx: myPageUserIdx) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mypageData = data as? MypageData {
                    userNicknameLabel.text = "\(mypageData.userNickname)의 체리쉬가든"
                    userWateringCountLabel.text = "\(mypageData.waterCount)"
                    userWateringPostponeCountLabel.text = "\(mypageData.postponeCount)"
                    userGrowCompleteCountLabel.text = "\(mypageData.completeCount)"
                    mypagePlantCount = mypageData.result.count
                    
                    myPlantID.removeAll()
                    // 소중이들 아이디 정수 배열 만들기
                    for i in 0...mypagePlantCount-1 {
                        myPlantID.append(mypageData.result[i].id)
                    }
                    
                    UserDefaults.standard.set(myPlantID, forKey: "myCherishID")

                    print("1: my page main임 ㅎㅇㅎㅇ")
                    print(myPlantID)
                    UserDefaults.standard.set(myPlantID, forKey: "plantIDArray")
                    UserDefaults.standard.set(mypageData.email, forKey: "userEmail")
                    UserDefaults.standard.set(mypageData.userNickname, forKey: "userNickname")
                    

                    // Userdefaults에 저장된 contact 가져오기
                    if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
                        let contacts = try? PropertyListDecoder().decode([Friend].self, from: data)
                        
                        contactArray = contacts!
                        
                    }
                    mypageContactCount = contactArray.count
                    segmentView.setButtonTitles(buttonTitles: ["식물 \(mypagePlantCount)", "연락처 \(mypageContactCount)"])
                }
            case .requestErr(let msg):
                print(msg)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    // 검색뷰로 이동
    @IBAction func moveToSearchPlant(_ sender: Any) {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "MyPageSearchVC") as? MyPageSearchVC else {return}
        dvc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
    
    // 식물등록으로 이동
    @IBAction func moveToAddUser(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        
        guard let dvc = storyBoard.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar else {return}
        self.navigationController?.pushViewController(dvc, animated: true)
    }
}

//MARK: - UIScrollViewDelegate
extension MyPageVC: UIScrollViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        changingIndex = false
    }
    
    //MARK: - scrollDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView == mypageExternalSV {
            if !changingIndex{
                segmentView.setIndex(index: Int(round(mypageExternalSV.contentOffset.x / mypageExternalSV.frame.size.width)))
            }
            
            // horizontal scroll 시
            // 스크롤 영역보다 왼쪽으로 (0미만값으로) 스크롤 될 때
            if scrollView.contentOffset.x < 0 {
                // contentOffset.x 값을 왼쪽 최소값인 0으로 설정
                scrollView.contentOffset.x = 0
            }
            // 스크롤 영역보다 오른쪽으로 (375초과값으로) 스크롤 될 때
            else if scrollView.contentOffset.x > 375 {
                // contentOffset.x 값을 오른쪽 최대값인 375로 설정
                /// 이부분은 기기사이즈에 따라 달라지므로 autolayout 다시 살펴봐야함!
                scrollView.contentOffset.x = 375
            }
        }
        else {
            /// 스크롤 가장 상단이 되었을 때
            let  off = scrollView.contentOffset.y
            
            let d = mypageHeaderView.frame.height - stickyHeaderView.frame.height - 44
            
            if scrollView.contentOffset.y >= d {
                headerTopConstraint.constant = -d
                
                /// segment뷰가 NaviBar와 닿았고 scrollView가 plantSV일 때
                if scrollView == plantSV && contactSV.contentOffset.y < d {
                    
                    // NaviBar와 StatusBar의 백그라운드를 white로 변경
                    mypageNaviView.backgroundColor = .white
                    changeStatusBarBackgroundColor("white")
                    makeCornerRadiusView(stickyHeaderView,0)
                    
                    // floatingBtn 띄우기
                    setFloatingBtnOffset(addFloatingBtn, false, 300, off + 580, addFloatingBtn.frame.size.width, addFloatingBtn.frame.size.height)
                    
                    
                    contactSV.contentOffset.y = d
                }
                /// segment뷰가 NaviBar와 닿았고 scrollView가 contactSV일 때
                else if scrollView == contactSV && plantSV.contentOffset.y < d {
                    
                    // NaviBar와 StatusBar의 백그라운드를 white로 변경
                    mypageNaviView.backgroundColor = .white
                    changeStatusBarBackgroundColor("white")
                    makeCornerRadiusView(stickyHeaderView,0)
                    
                    // floatingBtn 띄우기
                    setFloatingBtnOffset(addFloatingBtn, false, 300, off + 580, addFloatingBtn.frame.size.width, addFloatingBtn.frame.size.height)

                    
                    plantSV.contentOffset.y = d
                }
            }
            else {
                
                plantSV.contentOffset.y = scrollView.contentOffset.y
                contactSV.contentOffset.y = scrollView.contentOffset.y
                
                
                // segment뷰가 NaviBar와 닿았을 때 NaviBar와 StatusBar의 백그라운드를 mypageBackground로 변경
                mypageNaviView.backgroundColor = .mypageBackgroundGrey
                changeStatusBarBackgroundColor("mypageBackground")
                
                //stickyHeaderView의 라운드 값을 30으로 설정
                makeCornerRadiusView(stickyHeaderView,30)
                
                //floatingBtn hidden!
                setFloatingBtnOffset(addFloatingBtn, true, 305, off + 580, addFloatingBtn.frame.size.width, addFloatingBtn.frame.size.height)
                
                
                /// scrollView가 원래 자리로 돌아왔을 때
                if scrollView.contentOffset.y <= 0 {
                    
                    
                    headerTopConstraint.constant = 0
                    headerHeightConstraint.constant = 321 - scrollView.contentOffset.y
                    
                }
                else {
                    headerTopConstraint.constant = -scrollView.contentOffset.y
                    
                }
                
            }
            
        }
        
    }
    
}

//MARK: - CustomSegmentedControlDelegate
extension MyPageVC: CustomSegmentedControlDelegate {
    
    func change(to index: Int) {
        changingIndex = true
        let x = segmentView.selectedIndex * Int(mypageExternalSV.frame.width)
        mypageExternalSV.setContentOffset(CGPoint(x:x, y:0), animated: true)
        
        print(mypageExternalSV.contentInset.left)
        
    }
}
