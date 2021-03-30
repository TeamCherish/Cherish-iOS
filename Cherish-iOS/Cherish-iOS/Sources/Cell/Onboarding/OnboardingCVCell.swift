//
//  OnboardingCVCell.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/03/30.
//

import UIKit

class OnboardingCVCell: UICollectionViewCell {
    static let identifier = "OnboardingCVCell"
    
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var titleLabel: CustomLabel!
    @IBOutlet weak var descriptionLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCell(imageName: String, title: String, description: String){
        onboardingImageView.image = UIImage(named: imageName)
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "OnboardingCVCell", bundle: nil)
    }
    
    override func prepareForReuse() {
        self.descriptionLabel.text = ""
        self.titleLabel.text = ""
        self.onboardingImageView.image = UIImage()
    }
    
}
