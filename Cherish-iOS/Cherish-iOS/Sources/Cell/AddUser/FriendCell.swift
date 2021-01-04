//
//  FriendCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/04.
//

import UIKit

class FriendCell: UITableViewCell {
    static let identifier = "FriendCell"
    
    var isActive = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    
    @IBAction func radioBtnTapped(_ sender: Any) {
        if isActive {
            isActive = false
            radioBtn.setImage(UIImage(named: "btn_checkbox_selected"), for: .normal)
        }
        else {
            isActive = true
            radioBtn.setImage(UIImage(named: "btn_checkbox_unselected"), for: .normal)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    func setCell(friend: Friend) {
        nameLabel.text = friend.name
        phoneNumberLabel.text = friend.phoneNumber
    }
    
    func setName(name: String) {
        nameLabel.text = name
    }
    
    func setPhoneNumber(phoneNumber: String) {
        phoneNumberLabel.text = phoneNumber
    }
}
