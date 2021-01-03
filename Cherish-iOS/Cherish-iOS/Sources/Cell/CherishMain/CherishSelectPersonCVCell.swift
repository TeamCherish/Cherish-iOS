//
//  CherishSelectPersonCVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishSelectPersonCVCell: UICollectionViewCell {
    @IBOutlet var eclipseImageView: UIImageView!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var userWaterImageView: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    
    override func awakeFromNib() {
        makeShadow()
    }
    
    func makeShadow(){
        userWaterImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        userWaterImageView.layer.shadowRadius = 15
        userWaterImageView.layer.shadowOpacity = 0.10
    }
}
