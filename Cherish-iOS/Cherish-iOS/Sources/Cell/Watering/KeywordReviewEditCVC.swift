//
//  KeywordReviewEditCVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/13.
//

import UIKit

class KeywordReviewEditCVC: UICollectionViewCell {
    static let identifier = "KeywordReviewEditCVC"

    @IBOutlet weak var editKeywordCanDeleteView: UIView!{
        didSet{
            editKeywordCanDeleteView.makeRounded(cornerRadius: 15.0)
            editKeywordCanDeleteView.layer.borderColor = UIColor.textGrey.cgColor
            editKeywordCanDeleteView.layer.borderWidth  = 1.0
        }
    }
    @IBOutlet weak var eidtKeywordLabel: CustomLabel!
    @IBOutlet weak var eidtKeywordDeleteBtn: UIButton!{
        didSet{
            eidtKeywordDeleteBtn.tintColor = .textGrey
        }
    }
}
