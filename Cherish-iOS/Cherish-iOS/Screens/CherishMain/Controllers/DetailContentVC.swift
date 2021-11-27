//
//  DetailContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import Contacts
import Alamofire
import OverlayContainer

class DetailContentVC: BaseController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var cherishPeopleCountLabel: CustomLabel!
    @IBOutlet var cherishPeopleCV: UICollectionView!
    @IBOutlet var cherishHeaderViewHeight: NSLayoutConstraint!
    var selectedIndexPath : IndexPath?
    var sendCount:Int = 0
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    let userId: Int = UserDefaults.standard.integer(forKey: "userID")
    let fcmToken: String = UserDefaults.standard.string(forKey: "fcmToken")!
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    var pushCherishId: Int = 0
    var wateringLaterCherishId: Int = 0
    var pushCherishPhoneNumber: String = ""
    var mypageSelectedNickname: String = ""
    
    
    var cherishPeopleData:[ResultData] = [] {
        didSet {
            cherishPeopleCV.reloadData()
            cherishPeopleCV.delegate = self
            cherishPeopleCV.dataSource = self
            
            if appDel.isCherishAdded == false {
                cherishPeopleCV.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: .top)
                collectionView(self.cherishPeopleCV, didSelectItemAt: IndexPath(item: 1, section: 0))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addNotificationObserver()
        setCherishPeopleData()
        makeHeaderViewCornerRadius()
        cherishPeopleCV.allowsMultipleSelection = false
        fcmTokenUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //식물 추가했을 때 reload
        if appDel.isCherishAdded == true {
            setCherishPeopleDataWithGesture()
            appDel.isCherishAdded = false
        }
        
        //식물 삭제했을 때 reload
        if appDel.isCherishDeleted == true {
            setCherishPeopleDataWithGesture()
        }
        
        //식물 수정했을 때 reload
        if appDel.isCherishEdited == true {
            setCherishPeopleDataWithGesture()
            appDel.isCherishEdited = false
        }
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .addUser, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWhenFinishWatering), name: .postToReloadMainCell, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadDataWhenPostponed), name: .postPostponed, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenPushClickedViewUpdate), name: .pushSelected, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(whenWateringInMypage), name: .mypageWatering, object: nil)
    }
    
    //MARK: - 헤더 뷰 라운드로 만드는 함수
    func makeHeaderViewCornerRadius() {
        self.view.layer.cornerRadius = 30
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    //MARK: - 메인뷰 데이터 받아오는 함수
    func setCherishPeopleData() {
        
        MainService.shared.inquireMainView(idx: userId) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mainResultData = data as? MainData {
                    cherishPeopleData = mainResultData.result
                    cherishPeopleCountLabel.text = "\(cherishPeopleData.count)"
                    self.cherishPeopleCV.reloadData()
                    UserDefaults.standard.set(cherishPeopleData.count, forKey: "cherishPeopleDataCount")
                    // 남은 식물이 한개도 없을 때 식물 추가뷰를 띄워준다.
                    if cherishPeopleData.count == 0 {
                        UserDefaults.standard.set(false, forKey: "isPlantExist")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
                        if let vc = storyBoard.instantiateViewController(identifier: "AddUserVC") as? AddUserVC {

                            self.navigationController?.pushViewController(vc, animated: false)
                            
                            // 등록된 식물이 하나도 없을 경우에 탭바를 숨김
                            self.tabBarController?.tabBar.isHidden = true
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "isPlantExist")
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    
    //MARK: - 메인뷰 데이터 받아오는 함수
    func setCherishPeopleDataWithGesture() {
        
        MainService.shared.inquireMainView(idx: userId) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mainResultData = data as? MainData {
                    cherishPeopleData = mainResultData.result
                    cherishPeopleCountLabel.text = "\(cherishPeopleData.count)"
                    self.cherishPeopleCV.reloadData()
                    UserDefaults.standard.set(cherishPeopleData.count, forKey: "cherishPeopleDataCount")
                    
                    // 남은 식물이 한개도 없을 때 식물 추가뷰를 띄워준다.
                    if cherishPeopleData.count == 0 {
                        UserDefaults.standard.set(false, forKey: "isPlantExist")
                        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
                        if let vc = storyBoard.instantiateViewController(identifier: "AddUserVC") as? AddUserVC {
                            
                            self.navigationController?.pushViewController(vc, animated: false)
                            
                            // 등록된 식물이 하나도 없을 경우에 탭바를 숨김
                            self.tabBarController?.tabBar.isHidden = true
                            
                            // 등록된 식물이 하나도 없을 경우에 pop제스처 불가능하도록 만듬
                            navigationController?.interactivePopGestureRecognizer!.isEnabled = false
                        }
                    } else {
                        UserDefaults.standard.set(true, forKey: "isPlantExist")
                        navigationController?.interactivePopGestureRecognizer!.isEnabled = true
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    
    //MARK: - 물주기 후 정보를 reload하는 objc 함수
    @objc func reloadDataWhenFinishWatering() {
        setCherishPeopleData()
    }
    
    @objc func reloadDataWhenPostponed(_ notification: Notification) {
        if appDel.isCherishPostponed == true {
            let idData:Int = Int(notification.object as! Int)
            
            // UserDefaults의 선택된 친구 값도 바꿔준다!
            UserDefaults.standard.set(idData, forKey: "selectedFriendIdData")
            MainService.shared.inquireMainView(idx: userId) { [self]
                (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    if let mainResultData = data as? MainData {
                        cherishPeopleData = mainResultData.result
                        
                        for i in 0...cherishPeopleData.count - 1 {
                            if cherishPeopleData[i].id == idData {
                                wateringLaterCherishId = i + 1
                            }
                        }
                        print(wateringLaterCherishId)
                        
                        // 미루기를 한 친구(cherishId)를 클릭한 상태가 되기 위해 노티를 받아
                        // 바텀시트 컬렉션뷰의 선택된 셀 정보를 바꿔준다.
                        cherishPeopleCV.selectItem(at: IndexPath(item: wateringLaterCherishId, section: 0), animated: true, scrollPosition: .top)
                        collectionView(self.cherishPeopleCV, didSelectItemAt: IndexPath(item: wateringLaterCherishId, section: 0))
                    }
                case .requestErr(let msg):
                    if let message = msg as? String {
                        print(message)
                    }
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
            
            
            // MainContentVC에서도 푸시알림이 온 친구로 뷰 정보가 업데이트되어야하기 때문에
            // 셀이 눌렸다는 것을 알려주는 noti를 post!
            NotificationCenter.default.post(name: .cherishPeopleCellClicked, object: nil)
            appDel.isCherishPostponed = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){ [self] in
                setCherishPeopleData()
            }
        }
        
    }
    
    
    //MARK: - 푸시알림을 클릭했을 때 뷰를 업데이트하기위한 objc 함수
    @objc func whenPushClickedViewUpdate(_ notification: Notification) {
        
        let idData:Int = Int(notification.object as! String)!
        print("푸시", idData)
        
        if cherishPeopleData.count == 0 {
            setCherishPeopleData()
        }
        
        if cherishPeopleData.count >= 1 {
            for i in 0...cherishPeopleData.count - 1 {
                if cherishPeopleData[i].id == idData {
                    pushCherishId = i + 1
                    pushCherishPhoneNumber = cherishPeopleData[i].phone
                }
            }
        }
        
        // 푸시알림이 온 친구(cherishId)를 클릭한 상태가 되기 위해 노티를 받아
        // 바텀시트 컬렉션뷰의 선택된 셀 정보를 바꿔준다.
        cherishPeopleCV.selectItem(at: IndexPath(item: pushCherishId, section: 0), animated: true, scrollPosition: .top)
        collectionView(self.cherishPeopleCV, didSelectItemAt: IndexPath(item: pushCherishId, section: 0))
        
        
        // UserDefaults의 선택된 친구 값도 바꿔준다!
        UserDefaults.standard.set(idData, forKey: "selectedFriendIdData")
        UserDefaults.standard.set(pushCherishPhoneNumber, forKey: "selectedFriendPhoneData")
        cherishPeopleCV.reloadData()
        
        
        // MainContentVC에서도 푸시알림이 온 친구로 뷰 정보가 업데이트되어야하기 때문에
        // 셀이 눌렸다는 것을 알려주는 noti와 물주기 팝업뷰를 띄워주는 noti를 post!
        NotificationCenter.default.post(name: .cherishPeopleCellClicked, object: nil)
        NotificationCenter.default.post(name: .pushClickToWateringPopUp, object: nil)
    }
    
    
    //MARK: - 마이페이지에서 물을 줬을 때 뷰를 업데이트하기위한 objc 함수
    @objc func whenWateringInMypage(_ notification: Notification) {
        
        let idData: Int = notification.object as! Int
        print("마이페이지에서물주기",idData)
        
        if cherishPeopleData.count == 0 {
            setCherishPeopleData()
        }
        
        if cherishPeopleData.count >= 1 {
            
            for i in 0...cherishPeopleData.count - 1 {
                if cherishPeopleData[i].id == idData {
                    pushCherishId = i + 1
                    pushCherishPhoneNumber = cherishPeopleData[i].phone
                    mypageSelectedNickname = cherishPeopleData[i].nickname
                }
            }
        }
        
        // 푸시알림이 온 친구(cherishId)를 클릭한 상태가 되기 위해 노티를 받아
        // 바텀시트 컬렉션뷰의 선택된 셀 정보를 바꿔준다.
        cherishPeopleCV.selectItem(at: IndexPath(item: pushCherishId, section: 0), animated: true, scrollPosition: .top)
        collectionView(self.cherishPeopleCV, didSelectItemAt: IndexPath(item: pushCherishId, section: 0))
        
        
        // UserDefaults의 선택된 친구 값도 바꿔준다!
        UserDefaults.standard.set(idData, forKey: "selectedFriendIdData")
        UserDefaults.standard.set(pushCherishPhoneNumber, forKey: "selectedFriendPhoneData")
        UserDefaults.standard.set(mypageSelectedNickname, forKey: "selectedNickNameData")
        
        
        // MainContentVC에서도 푸시알림이 온 친구로 뷰 정보가 업데이트되어야하기 때문에
        // 셀이 눌렸다는 것을 알려주는 noti를 post!
        NotificationCenter.default.post(name: .whenMypageWateringMainReload, object: nil)
        NotificationCenter.default.post(name: .wateringReport, object: idData)
    }
    
    
    //MARK: - FCMToken Update func
    func fcmTokenUpdate() {
        // 서버에 업데이트된 fcmToken을 put
        FCMTokenUpdateService.shared.updateFCMToken(userId: userId, fcmToken: fcmToken) {
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    
    //MARK: - 친구추가 뷰로 이동
    @IBAction func moveToSelectFriend(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Collectionview Extension
extension DetailContentVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: - numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //MARK: - numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cherishPeopleData.count + 1
        
    }
    
    
    //MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// 선택된 아이템 표시하는 0번째 item
        if indexPath.item == 0 {
            
            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishSelectPersonCVC", for: indexPath) as! CherishSelectPersonCVC
            
            if cherishPeopleData.count != 0 {
                
                NotificationCenter.default.post(name: .sendPeopleDataArray, object: cherishPeopleData)
                
                let plantName = UserDefaults.standard.string( forKey: "selectedPlantName")
                
                // 셀이 눌리지 않은 상태 (cherishPeopleData의 첫번 째 데이터값으로 초기값을 설정해준다)
                if appDel.isCherishPeopleCellSelected == false {
                    
                    /// plantName에 따라 원형 이미지를 다르게 설정해주기 위한 분기처리
                    if plantName == "민들레" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgMinStorke")
                    }
                    else if plantName == "로즈마리" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgRoseStorke")
                    }
                    else if plantName == "단모환" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgSunStorke")
                    }
                    else if plantName == "스투키" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgStukiStorke")
                    }
                    //아메리칸블루
                    else {
                        firstCell.eclipseImageView.image = UIImage(named: "imgBlueStorke")
                    }
                    
                    firstCell.nickNameLabel.text = cherishPeopleData[0].nickname
                    firstCell.nickNameLabel?.textAlignment = .left
                    
                    
                    
                    if cherishPeopleData[0].dDay == 0 {
                        firstCell.userWaterImageView.image = UIImage(named: "mainIcUserWater")
                        firstCell.userWaterImageView.isHidden = false
                    }
                    else {
                        firstCell.userWaterImageView.isHidden = true
                    }
                    
                    /// 이미지 url 처리
                    if let url = URL(string: cherishPeopleData[0].thumbnailImageURL) {
                        if let imageData = try? Data(contentsOf: url) {
                            firstCell.plantImageView.image = UIImage(data: imageData)
                        }
                    }
                }
                
                // 셀이 한번 이상 눌린 상태
                else
                {
                    if plantName == "민들레" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgMinStorke")
                    }
                    else if plantName == "로즈마리" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgRoseStorke")
                    }
                    else if plantName == "단모환" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgSunStorke")
                    }
                    else if plantName == "스투키" {
                        firstCell.eclipseImageView.image = UIImage(named: "imgStukiStorke")
                    }
                    //아메리칸블루
                    else {
                        firstCell.eclipseImageView.image = UIImage(named: "imgBlueStorke")
                    }
                    
                    firstCell.nickNameLabel.text = UserDefaults.standard.string(forKey:"selectedNickNameData")
                    firstCell.nickNameLabel.textAlignment = .left
                    
                    /// dDay 값이 1 이하일 때 물아이콘 나타나게
                    if UserDefaults.standard.integer(forKey: "selecteddDayData") < 1 {
                        firstCell.userWaterImageView.image = UIImage(named: "mainIcUserWater")
                        firstCell.userWaterImageView.isHidden = false
                    }
                    else {
                        firstCell.userWaterImageView.isHidden = true
                    }
                    
                    /// 이미지 url 처리
                    if let url = URL(string: UserDefaults.standard.string(forKey:"selectedPlantNameData") ?? "https://cherish-bucket.s3.ap-northeast-2.amazonaws.com/thumbnail/circle_blue%403x.png") {
                        if let imageData = try? Data(contentsOf: url) {
                            firstCell.plantImageView.image = UIImage(data: imageData)
                        }
                    }
                }
            }
            return firstCell
        }
        
        /// 나머지 items
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishPeopleCVC", for: indexPath) as! CherishPeopleCVC
            
            if cherishPeopleData.count != 0 {
                
                cell.cherishNickNameLabel.text = cherishPeopleData[indexPath.row - 1].nickname
                cell.cherishNickNameLabel?.textAlignment = .left
                
                
                /// dDay 값이 1 이하일 때 물아이콘 나타나게
                if cherishPeopleData[indexPath.row - 1].dDay < 1 {
                    cell.cherishUserWaterImageView.image = UIImage(named: "mainIcUserWater")
                    cell.cherishUserWaterImageView.isHidden = false
                }
                else {
                    cell.cherishUserWaterImageView.isHidden = true
                }
                
                cell.tag = indexPath.row
                
                /// 이미지 url 처리
                DispatchQueue.global(qos: .default).async(execute: { [self]() -> Void in
                    
                    if let url = URL(string: cherishPeopleData[indexPath.row - 1].thumbnailImageURL) {
                        if let imageData = try? Data(contentsOf: url) {
                            DispatchQueue.main.async(execute: {() -> Void in
                                
                                if(cell.tag == indexPath.row) {
                                    cell.cherishPlantImageView.image = UIImage(data: imageData)
                                }
                            })
                        }
                    }
                })
                
                /// 선택된 친구셀 블러처리
                if indexPath == selectedIndexPath {
                    cell.cherishPlantImageView.alpha = 0.3
                    cell.cherishNickNameLabel.alpha = 0.3
                } else {
                    cell.cherishPlantImageView.alpha = 1
                    cell.cherishNickNameLabel.alpha = 1
                }
                return cell
            }
            return cell
        }
    }
    
    //MARK: - sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if screenWidth >= 414 && screenHeight >= 896 {
            cherishHeaderViewHeight.constant = 66.7
            return CGSize(width: 76.2, height: 100.4)
        }
        else {
            return CGSize(width: 69, height: 91)
        }
    }
    
    
    //MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item > 0 {
            
            if cherishPeopleData.count != 0 {
                
                // appDelegate에 전역변수를 생성해주고, 한번 셀이 눌린 후로는 그 값을 true로 바꿔준다
                appDel.isCherishPeopleCellSelected = true
                
                // 셀이 눌릴 때마다 UserDefaults에 값을 새로 저장해준다
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].nickname, forKey: "selectedNickNameData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].thumbnailImageURL, forKey: "selectedPlantNameData")
                UserDefaults.standard.set(true, forKey: "selectedData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].growth, forKey: "selectedGrowthData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].dDay, forKey: "selecteddDayData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].modifier, forKey: "selectedModifierData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].plantName, forKey: "selectedPlantName")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].gif, forKey: "selectedGif")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].main_bg, forKey: "selectedMainBg")
                
                
                //선택된 친구의 인덱스 값과 전화번호를 저장해준다
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].id, forKey: "selectedFriendIdData")
                UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].phone, forKey: "selectedFriendPhoneData")
                UserDefaults.standard.set(indexPath.row - 1, forKey: "selectedRowIndexPath")
                
                selectedIndexPath = indexPath
                
                UIView.performWithoutAnimation {
                    cherishPeopleCV.reloadData()
                    cherishPeopleCV.reloadItems(at: [IndexPath(item: 0, section: 0)])
                }
                
            }
            // 셀이 눌렸을 때 노치 사이즈 줄어들기 위해 보내는 noti
            NotificationCenter.default.post(name: .cherishPeopleCellClicked, object: nil)
        }
    }
}
