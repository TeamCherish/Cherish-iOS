//
//  CherishPeopleCVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishPeopleCVC: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                print("select")
                backgroundColor = .blueyGrey
            } else {
                print("unselect")
                backgroundColor = .white
            }
        }
    }
    
    
    @IBOutlet var cherishPlantImageView: UIImageView!
    @IBOutlet var cherishUserWaterImageView: UIImageView!
    @IBOutlet var cherishNickNameLabel: UILabel!
    
    override func awakeFromNib() {
        makeShadow()
    }
    
    func makeShadow(){
        cherishUserWaterImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cherishUserWaterImageView.layer.shadowRadius = 15
        cherishUserWaterImageView.layer.shadowOpacity = 0.15
    }
}
