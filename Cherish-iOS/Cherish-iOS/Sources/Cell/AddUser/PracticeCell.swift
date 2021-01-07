//
//  PracticeCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/07.
//

import UIKit

class PracticeCell: UITableViewCell {
    static let identifier = "PracticeCell"
    @IBOutlet weak var radioBtnImg: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
