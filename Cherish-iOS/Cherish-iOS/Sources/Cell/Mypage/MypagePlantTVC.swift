//
//  MypagePlantTVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypagePlantTVC: UITableViewCell {

    @IBOutlet var mypagePlantImageView: UIImageView!
    @IBOutlet var mypagePlantNicknameLabel: CustomLabel!
    @IBOutlet var mypagePlantTypeLabel: CustomLabel!
    @IBOutlet var mypagePlantWateringDdayLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProperties(_ imageURL:String, _ nickname:String,_ plantType:String,_ wateringDay:String){
        mypagePlantImageView.image = UIImage(named: imageURL)
        mypagePlantNicknameLabel.text = nickname
        mypagePlantTypeLabel.text = plantType
        mypagePlantWateringDdayLabel.text = wateringDay
    }

}
