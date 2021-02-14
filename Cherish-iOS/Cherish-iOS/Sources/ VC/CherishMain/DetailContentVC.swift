//
//  DetailContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import Contacts
import Alamofire
import Kingfisher
import OverlayContainer

class DetailContentVC: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var cherishPeopleCountLabel: CustomLabel!
    @IBOutlet var cherishPeopleCV: UICollectionView!
    var selectedIndexPath : IndexPath?
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        setCherishPeopleData()
        makeHeaderViewCornerRadius()
        cherishPeopleCV.allowsMultipleSelection = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewWillAppear), name: .postPostponed, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //이 거 때 문 이 다
        if appDel.isCherishAdded == true || appDel.isWateringPostponed == true  {
            setCherishPeopleData()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: .postPostponed, object: nil)
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
        
        MainService.shared.inquireMainView(idx: UserDefaults.standard.integer(forKey: "userID")) { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mainResultData = data as? MainData {
                    
                    
                    cherishPeopleData = mainResultData.result
                    cherishPeopleCountLabel.text = "\(cherishPeopleData.count)"
                    self.cherishPeopleCV.reloadData()
                }
            case .requestErr(let msg):
                if let message = msg as? String {
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
    
    // numberOfSections
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // numberOfItemsInSection
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cherishPeopleData.count + 1
        
    }
    
    
    //MARK: - cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        /// 선택된 아이템 표시하는 0번째 item
        if indexPath.item == 0 {
            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishSelectPersonCVC", for: indexPath) as! CherishSelectPersonCVC
            
            if cherishPeopleData.count != 0 {
                
                var plantName = UserDefaults.standard.string( forKey: "selectedPlantName")
                
                // 셀이 눌리지 않은 상태 (cherishPeopleData의 첫번 째 데이터값으로 초기값을 설정해준다)
                if appDel.isCherishPeopleCellSelected == false {
                    print("first")
                    
                    /// plantName에 따라 원형 이미지를 다르게 설정해주기 위한 분기처리
                    if plantName == "민들레" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                    }
                    else if plantName == "로즈마리" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse375")
                    }
                    else if plantName == "단모환" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse377")
                    }
                    else if plantName == "스투키" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse374")
                    }
                    //아메리칸블루
                    else {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse376")
                    }
                    
                    firstCell.nickNameLabel.text = cherishPeopleData[0].nickname
                    
                    if cherishPeopleData[0].dDay == 0 {
                        firstCell.userWaterImageView.image = UIImage(named: "mainIcUserWater")
                        firstCell.userWaterImageView.isHidden = false
                    }
                    else {
                        firstCell.userWaterImageView.isHidden = true
                    }
                    
                    /// 이미지 url 처리
                    let url = URL(string: cherishPeopleData[0].thumbnailImageURL ?? "")
                    let imageData = try? Data(contentsOf: url!)
                    firstCell.plantImageView.image = UIImage(data: imageData!)
                }
                
                // 셀이 한번 이상 눌린 상태
                else
                {
                    print("else")
                    if plantName == "민들레" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                    }
                    else if plantName == "로즈마리" {
                        print("로즈마리")
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse375")
                    }
                    else if plantName == "단모환" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse377")
                    }
                    else if plantName == "스투키" {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse374")
                    }
                    //아메리칸블루
                    else {
                        firstCell.eclipseImageView.image = UIImage(named: "ellipse376")
                    }
                    
                    firstCell.nickNameLabel.text = UserDefaults.standard.string(forKey:"selectedNickNameData")
                    
                    /// dDay 값이 1 이하일 때 물아이콘 나타나게
                    if UserDefaults.standard.integer(forKey: "selecteddDayData") < 1 {
                        firstCell.userWaterImageView.image = UIImage(named: "mainIcUserWater")
                        firstCell.userWaterImageView.isHidden = false
                    }
                    else {
                        firstCell.userWaterImageView.isHidden = true
                    }
                    
                    /// 이미지 url 처리
                    let url = URL(string: UserDefaults.standard.string(forKey:"selectedPlantNameData")!)
                    let imageData = try? Data(contentsOf: url!)
                    firstCell.plantImageView.image = UIImage(data: imageData!)
                }
            }
            
            return firstCell
        }
        
        /// 나머지 items
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishPeopleCVC", for: indexPath) as! CherishPeopleCVC
            
            if cherishPeopleData.count != 0 {
                
                cell.cherishNickNameLabel.text = cherishPeopleData[indexPath.row - 1].nickname
                
                
                /// dDay 값이 1 이하일 때 물아이콘 나타나게
                if cherishPeopleData[indexPath.row - 1].dDay < 1 {
                    cell.cherishUserWaterImageView.image = UIImage(named: "mainIcUserWater")
                    cell.cherishUserWaterImageView.isHidden = false
                }
                else {
                    cell.cherishUserWaterImageView.isHidden = true
                }
                
                
                /// 이미지 url 처리
                let url = URL(string: cherishPeopleData[indexPath.row - 1].thumbnailImageURL)
                DispatchQueue.global(qos: .default).async(execute: {() -> Void in
                    let imageData = try? Data(contentsOf: url!)
                    DispatchQueue.main.async(execute: {() -> Void in
                        cell.cherishPlantImageView.image = UIImage(data: imageData!)
                    })
                })
                
                
                /// 선택된 친구셀 블러처리
                if indexPath == selectedIndexPath {
                    cell.cherishPlantImageView.alpha = 0.5
                } else {
                    cell.cherishPlantImageView.alpha = 1
                }
                return cell
                
                
            }
            
            return cell
        }
    }
    
    // sizeForItemAt
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 69, height: 91)
    }
    
    
    //MARK: - didSelectItemAt
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item > 0 {
            
            
            // appDelegate에 전역변수를 생성해주고, 한번 셀이 눌린 후로는 그 값을 true로 바꿔준다
            appDel.isCherishPeopleCellSelected = true
            print(indexPath.row - 1)
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
