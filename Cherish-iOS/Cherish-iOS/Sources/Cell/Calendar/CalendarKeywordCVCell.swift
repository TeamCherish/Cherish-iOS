//
//  CalendarKeywordCVCell.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/06.
//

import UIKit

class CalendarKeywordCVCell: UICollectionViewCell {
    static let identifier = "CalendarKeywordCVCell"
    
    @IBOutlet weak var calendarKeywordView: UIView!{
        didSet{
            calendarKeywordView.makeRounded(cornerRadius: 13.0)
            calendarKeywordView.backgroundColor = .calendarKeywordBack
        }
    }
    @IBOutlet weak var calendarKeywordLabel: CustomLabel!{
        didSet{
            calendarKeywordLabel.textColor = .calendarKeywordText
        }
    }
    static func nib() -> UINib {
        return UINib(nibName: "CalendarKeywordCVCell", bundle: nil)
    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }

}
