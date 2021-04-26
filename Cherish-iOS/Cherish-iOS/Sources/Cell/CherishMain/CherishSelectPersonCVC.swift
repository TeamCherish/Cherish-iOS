//
//  CherishSelectPersonCVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class CherishSelectPersonCVC: UICollectionViewCell {
    @IBOutlet var eclipseImageView: UIImageView!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var userWaterImageView: UIImageView!
    @IBOutlet var nickNameLabel: UILabel!
    @IBOutlet var userNameLabelLeftPadding: NSLayoutConstraint!
    
    override func awakeFromNib() {
        makeShadow()
    }
    
    override func layoutSubviews() {
        textAlign()
    }
    
    func makeShadow() {
        userWaterImageView.layer.cornerRadius = userWaterImageView.frame.height / 2
        userWaterImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        userWaterImageView.layer.shadowRadius = 15
        userWaterImageView.layer.shadowOpacity = 0.10
    }
    
    func textAlign() {
        if nickNameLabel.text!.count < 9 {
            nickNameLabel.textAlignment = NSTextAlignment.center
        }
        else {
            nickNameLabel.textAlignment = NSTextAlignment.left
        }
    }
    
    override func prepareForReuse() {
        self.eclipseImageView.image = UIImage()
        self.plantImageView.image = UIImage()
        self.userWaterImageView.image = UIImage()
        self.nickNameLabel.text = ""
    }
}
