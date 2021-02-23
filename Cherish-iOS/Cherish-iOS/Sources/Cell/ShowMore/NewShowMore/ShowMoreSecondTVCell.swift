//
//  ShowMoreSecondTVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/23.
//

import UIKit

class ShowMoreSecondTVCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pushAlarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resizeUISwitch()
    }
    
    func resizeUISwitch() {
        pushAlarmSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
