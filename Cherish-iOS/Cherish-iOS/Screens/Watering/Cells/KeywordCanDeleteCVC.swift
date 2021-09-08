//
//  KeywordCanDeleteCVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/05.
//

import UIKit

class KeywordCanDeleteCVC: UICollectionViewCell {
    static let identifier = "KeywordCanDeleteCVC"

    @IBOutlet weak var keywordCanDeleteView: UIView!{
        didSet{
            keywordCanDeleteView.makeRounded(cornerRadius: 14.0)
            keywordCanDeleteView.layer.borderColor = UIColor.textGrey.cgColor
            keywordCanDeleteView.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var keywordLabel: CustomLabel!
    @IBOutlet weak var keywordDeleteBtn: UIButton!{
        didSet{
            keywordDeleteBtn.tintColor = .textGrey
        }
    }
}
