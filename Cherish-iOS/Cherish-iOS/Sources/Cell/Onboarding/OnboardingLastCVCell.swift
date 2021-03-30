//
//  OnboardingLastCVCell.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/30.
//

import UIKit

class OnboardingLastCVCell: UICollectionViewCell {
    static let identifier = "OnboardingLastCVCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    static func nib() -> UINib {
        return UINib(nibName: "OnboardingLastCVCell", bundle: nil)
    }
}
