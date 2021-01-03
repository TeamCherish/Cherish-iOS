//
//  keywordCVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/04.
//

import UIKit

class KeywordCVC: UICollectionViewCell {
    static let identifier = "KeywordCVC"
    

    @IBOutlet weak var keywordView: UIView!{
        didSet{
            keywordView.makeRounded(cornerRadius: 15.0)
            keywordView.layer.borderColor = UIColor.black.cgColor
            keywordView.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var keywordLabel: UILabel!{
        didSet{
            keywordLabel.textColor = .black
        }
    }
    


    static func nib() -> UINib {
        return UINib(nibName: "KeywordCVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
