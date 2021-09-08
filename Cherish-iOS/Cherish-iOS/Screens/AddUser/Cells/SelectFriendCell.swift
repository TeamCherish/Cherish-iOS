//
//  SelectFriendCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/08.
//

import UIKit

class SelectFriendCell: UITableViewCell {
        
    static let identifier = "SelectFriendCell"
    
    // 1
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var btnImage: UIImageView!
    
    // 2
    private let checked = UIImage(named: "btn_checkbox_selected")
    private let unchecked = UIImage(named: "btn_checkbox_unselected")
    
    //3
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //4
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // 5
    public func configureName(_ text: String) {
        nameLabel.text = text
    }
    public func configurePhone(_ text: String) {
        phoneNumberLabel.text = text
    }
    
    // 6
    public func isselected(_ selected: Bool) {
        setSelected(selected, animated: false)
        let image = selected ? checked : unchecked
        btnImage.image = image
//        NotificationCenter.default.post(name: .radioBtnClicked, object: nil)
    }
    
}
