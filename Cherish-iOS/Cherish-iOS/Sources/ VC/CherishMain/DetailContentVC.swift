//
//  DetailContentVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit
import OverlayContainer

class DetailContentVC: UIViewController {
    
    @IBOutlet var headerView: UIView!
    @IBOutlet var cherishPeopleCV: UICollectionView!
    var cherishPeopleData:[CherishPeopleData] = []
    let appDel : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cherishPeopleCV.delegate = self
        cherishPeopleCV.dataSource = self
        makeHeaderViewCornerRadius()
        setCherishPeopleData()
    }
    
    func makeHeaderViewCornerRadius() {
        self.view.layer.cornerRadius = 30
        headerView.clipsToBounds = true
        headerView.layer.cornerRadius = 30
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    func setCherishPeopleData() {
        cherishPeopleData.append(contentsOf: [
            CherishPeopleData(nickName: "지은둥이", plantImageName: "mainImgUser1"),
            CherishPeopleData(nickName: "원석둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "서현둥이", plantImageName: "mainImgUser4"),
            CherishPeopleData(nickName: "남궁둥이", plantImageName: "mainImgUser5"),
            CherishPeopleData(nickName: "소령둥이", plantImageName: "mainImgUser1"),
            CherishPeopleData(nickName: "민지둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "수아둥이", plantImageName: "mainImgUser5"),
            CherishPeopleData(nickName: "영은둥이", plantImageName: "mainImgUser4"),
            CherishPeopleData(nickName: "궁권둥이", plantImageName: "mainImgUser5"),
            CherishPeopleData(nickName: "원탁둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "울이둥이", plantImageName: "mainImgUser1"),
            CherishPeopleData(nickName: "정민둥이", plantImageName: "mainImgUser1"),
            CherishPeopleData(nickName: "훈기둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "나영둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "예진둥이", plantImageName: "mainImgUser5"),
            CherishPeopleData(nickName: "아요둥이", plantImageName: "mainImgUser4"),
            CherishPeopleData(nickName: "안드둥이", plantImageName: "mainImgUser4"),
            CherishPeopleData(nickName: "디쟌둥이", plantImageName: "mainImgUser1"),
            CherishPeopleData(nickName: "서버둥이", plantImageName: "mainImgUser2"),
            CherishPeopleData(nickName: "기획둥이", plantImageName: "mainImgUser5"),
        ])
    }
  
}
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
            
            // 셀이 눌리지 않은 상태
            if appDel.isCherishPeopleCellSelected == false {
                firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                firstCell.nickNameLabel.text = cherishPeopleData[0].nickName
                firstCell.plantImageView.image = UIImage(named: cherishPeopleData[0].plantImageName)
            }
            // 셀이 한번 이상 눌린 상태
            else
            {
                firstCell.eclipseImageView.image = UIImage(named: "ellipse373")
                firstCell.nickNameLabel.text = UserDefaults.standard.string(forKey:"selectedNickNameData")
                firstCell.plantImageView.image = UIImage(named: UserDefaults.standard.string(forKey:"selectedPlantNameData")!)
            }
            return firstCell
        }
        
        /// 나머지 items
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CherishPeopleCVC", for: indexPath) as! CherishPeopleCVC
            
            cell.cherishNickNameLabel.text = cherishPeopleData[indexPath.row - 1].nickName
            cell.cherishPlantImageView.image = UIImage(named: cherishPeopleData[indexPath.row - 1].plantImageName)
            
            
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
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].nickName, forKey: "selectedNickNameData")
            UserDefaults.standard.set(cherishPeopleData[indexPath.row - 1].plantImageName, forKey: "selectedPlantNameData")
            UserDefaults.standard.set(true, forKey: "selectedData")
            
            cherishPeopleCV.reloadData()
        }
        
        
        // 셀이 눌렸을 때 노치 사이즈 줄어들기 위해 보내는 noti
        NotificationCenter.default.post(name: .cherishPeopleCellClicked, object: nil)
        
    }
}
