//
//  SearchPlantCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class SearchPlantCell: UITableViewCell {
    
    static let identifier = "SearchPlantCell"

    @IBOutlet weak var myPlantImageView: UIImageView!
    @IBOutlet weak var myPlantNameLabel: UILabel!
    @IBOutlet weak var myPlantInfoLabel: UILabel!
    @IBOutlet weak var plantDay: CustomLabel!
    @IBOutlet weak var dayCornerView: UIView!
    
    
    let pinkSub:CGColor = CGColor(red: 247/255, green: 89/255, blue: 108/255, alpha: 1.0)
    let seaweed:CGColor = CGColor(red: 26/255, green: 210/255, blue: 135/255, alpha: 1.0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func makeRadiusView(){
        dayCornerView.layer.borderWidth = 1.15
        dayCornerView.layer.cornerRadius = 13
    }
    
//    func setProperties(_ imageData:Data, _ nickname:String,_ plantType:String,_ wateringDay:Int){
//        mypagePlantImageView.image = UIImage(data: imageData)
//        mypagePlantNicknameLabel.text = nickname
//        mypagePlantTypeLabel.text = plantType
    
    func setCellProperty(_ imageData: Data, _ nickname: String, _ plantType: String, _ wateringDay: Int) {
        if wateringDay == 0 {
            self.plantDay.text = "D-day"
            self.plantDay.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        else if wateringDay < 0 {
            self.plantDay.text = "D+\(-wateringDay)"
            self.plantDay.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        else {
            // dDay가 1일 때만
            if wateringDay == 1 {
                // 메인뷰에서 적용되는 물 아이콘이 표시되는 기준에 맞춰
                // 물주기가 임박했음을 알려주기 위해 pinkSub 컬러 적용
                self.plantDay.textColor = .pinkSub
                dayCornerView.layer.borderColor = pinkSub
            }
            self.plantDay.text = "D-\(wateringDay)"
            self.plantDay.textColor = .seaweed
            dayCornerView.layer.borderColor = seaweed
        }
    }
    
}
