//
//  CherishPeopleCVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishPeopleCVC: UICollectionViewCell {
    
    @IBOutlet var cherishPlantImageView: UIImageView!
    @IBOutlet var cherishUserWaterImageView: UIImageView!
    @IBOutlet var cherishNickNameLabel: UILabel!
    
    override func prepareForReuse() {
        //이미지가 로딩될 때 셀에 다른 이미지가 표시된 후 이미지가 로드되는 이슈
        //셀 재사용 시 image에 nil값을 배정하는 걸로 해결
        cherishPlantImageView.image = nil
      }
    
    
    override func awakeFromNib() {
        makeShadow()
    }
    
    func makeShadow(){
        cherishUserWaterImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cherishUserWaterImageView.layer.shadowRadius = 15
        cherishUserWaterImageView.layer.shadowOpacity = 0.15
    }
    
}
