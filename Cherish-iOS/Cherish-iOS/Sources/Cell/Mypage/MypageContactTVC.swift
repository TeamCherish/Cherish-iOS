//
//  MypageContactTVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypageContactTVC: UITableViewCell {
    
    static let identifier = "MypageContactTVC"
    
    @IBOutlet var friendsImageView: UIImageView!
    @IBOutlet var friendsNameLabel: CustomLabel!
    @IBOutlet var friendsContactNumberLabel: CustomLabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProperties(_ friendsName:String,_ friendsContactNumber:String){
        friendsNameLabel.text = friendsName
        friendsContactNumberLabel.text = friendsContactNumber
    }
}
