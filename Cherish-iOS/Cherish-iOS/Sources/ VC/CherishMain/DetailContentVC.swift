//
//  DetailContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import Alamofire
import Kingfisher
import OverlayContainer

class DetailContentVC: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var cherishPeopleCountLabel: CustomLabel!
    @IBOutlet var cherishPeopleCV: UICollectionView!
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var cherishPeopleData:[ResultData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCherishPeopleData()
        cherishPeopleCV.delegate = self
        cherishPeopleCV.dataSource = self
        makeHeaderViewCornerRadius()
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
        
        MainService.shared.inquireMainView(idx: UserDefaults.standard.integer(forKey: "userID")) {
            (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let mainResultData = data as? MainData {
                    self.cherishPeopleData = mainResultData.result
                    self.cherishPeopleCountLabel.text = "\(self.cherishPeopleData.count)"
                    self.cherishPeopleCV.reloadData()
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
    
    
    //MARK: - 친구추가 뷰로 이동
    @IBAction func moveToSelectFriend(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - Collectionview Delegate, DataSource, DelegateFlowLayout
extension DetailContentVC:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return cherishPeopleData.count + 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        /// 선택된 아이템 표시하는 0번째 item
        if indexPath.item == 0 {
            let firstCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishSelectPersonCVC", for: indexPath) as! CherishSelectPersonCVC
            
            if cherishPeopleData.count != 0 {
                
                // 셀이 눌리지 않은 상태
                if appDel.isCherishPeopleCellSelected == false {
                    firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                    firstCell.nickNameLabel.text = cherishPeopleData[0].nickname
                    
                    print(cherishPeopleData)
                    /// 이미지 url 처리
//                    let url = URL(string: cherishPeopleData[0].thumbnailImageURL ?? "")
//                    let imageData = try? Data(contentsOf: url!)
//                    firstCell.plantImageView.image = UIImage(data: imageData!)
                }
                
                // 셀이 한번 이상 눌린 상태
                else
                {
                    firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                    firstCell.nickNameLabel.text = UserDefaults.standard.string(forKey:"selectedNickNameData")
                    
                    /// 이미지 url 처리
//                    let url = URL(string: UserDefaults.standard.string(forKey:"selectedPlantNameData")!)
//                    let imageData = try? Data(contentsOf: url!)
//                    firstCell.plantImageView.image = UIImage(data: imageData!)
                }
            }
            
            return firstCell
        }
        
        /// 나머지 items
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishPeopleCVC", for: indexPath) as! CherishPeopleCVC
            
            if cherishPeopleData.count != 0 {
                cell.cherishNickNameLabel.text = cherishPeopleData[indexPath.row - 1].nickname
                
                /// 이미지 url 처리
//                let url = URL(string: cherishPeopleData[indexPath.row - 1].thumbnailImageURL!)
//                let imageData = try? Data(contentsOf: url!)
//                cell.cherishPlantImageView.image = UIImage(data: imageData!)
            }
            
            return cell
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 69, height: 91)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        if indexPath.item > 0 {
            // appDelegate에 전역변수를 생성해주고, 한번 셀이 눌린 후로는 그 값을 true로 바꿔준다
            appDel.isCherishPeopleCellSelected = true
            
            // 셀이 눌릴 때마다 UserDefaults에 값을 새로 저장해준다
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].nickname, forKey: "selectedNickNameData")
//            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].thumbnailImageURL!, forKey: "selectedPlantNameData")
            UserDefaults.standard.set(true, forKey: "selectedData")
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].growth, forKey: "selectedGrowthData")
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].dDay, forKey: "selecteddDayData")
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].id, forKey: "selectedFriendsIdData")
            
            cherishPeopleCV.reloadData()
        }
        
        
        // 셀이 눌렸을 때 노치 사이즈 줄어들기 위해 보내는 noti
        NotificationCenter.default.post(name: .cherishPeopleCellClicked, object: nil)
        
    }
}
