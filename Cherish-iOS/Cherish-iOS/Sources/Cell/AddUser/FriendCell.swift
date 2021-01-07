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
//    var btnTapped = false
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var radioBtn: UIButton!
    
    var btnTapped = false
    var activeBtn = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @IBAction func btnSelected(_ sender: UIButton) {
        if btnTapped {
            btnTapped = false
            radioBtn.setImage(UIImage(named: "btn_checkbox_selected"), for: .normal)
            activeBtn = true
            NotificationCenter.default.post(name: .radioBtnClicked, object: nil)
            print("cell: true")
        }
        else {
            btnTapped = true
            radioBtn.setImage(UIImage(named: "btn_checkbox_unselected"), for: .normal)
            activeBtn = false
            print("cell: false")
        }
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
    
    
    //MARK: - 라디오 버튼 클릭하면 이미지 바뀌기
//    func btnAction(btnTapped: Bool){
//        if btnTapped == true{
//            self.btnTapped = false
//            radioBtn.setImage(UIImage(named: "btn_checkbox_selected"), for: .normal)
//        }
//        else {
//            self.btnTapped = true
//            radioBtn.setImage(UIImage(named: "btn_checkbox_unselected"), for: .normal)
//        }
//    }
}
