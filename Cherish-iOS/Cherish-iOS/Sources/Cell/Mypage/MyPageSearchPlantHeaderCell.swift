//
//  MyPageSearchPlantHeaderCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class MyPageSearchPlantHeaderCell: UITableViewCell {
    
    static let identifier = "MyPageSearchPlantHeaderCell"

    @IBOutlet weak var plantNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        plantNumberLabel.text = String(UserDefaults.standard.integer(forKey: "totalCherish"))
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
