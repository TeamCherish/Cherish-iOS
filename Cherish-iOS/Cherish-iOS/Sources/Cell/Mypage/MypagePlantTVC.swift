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
    @IBOutlet var mypagePlantWateringDdayLabel: CustomLabel!
    @IBOutlet var dayCornerView: UIView!
    let pinkSub:CGColor = CGColor(red: 247/255, green: 89/255, blue: 108/255, alpha: 1.0)
    let seaweed:CGColor = CGColor(red: 26/255, green: 210/255, blue: 135/255, alpha: 1.0)
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        makeRadiusView()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func makeRadiusView(){
        dayCornerView.layer.borderWidth = 1.15
        dayCornerView.layer.cornerRadius = 13
    }
    
    func setProperties(_ imageData:Data, _ nickname:String,_ plantType:String,_ wateringDay:Int){
        mypagePlantImageView.image = UIImage(data: imageData)
        mypagePlantNicknameLabel.text = nickname
        mypagePlantTypeLabel.text = plantType
        
        /// dDay 값 파싱 -,+,0
        // dDay가 0일 때
        if wateringDay == 0 {
            self.mypagePlantWateringDdayLabel.text = "D-day"
            self.mypagePlantWateringDdayLabel.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        // dDay가 0 이하일 때 (D+)
        else if wateringDay < 0 {
            self.mypagePlantWateringDdayLabel.text = "D+\(-wateringDay)"
            self.mypagePlantWateringDdayLabel.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        // dDay가 0 초과일 때 (D+)
        else {
            // dDay가 1일 때만
            if wateringDay == 1 {
                // 메인뷰에서 적용되는 물 아이콘이 표시되는 기준에 맞춰
                // 물주기가 임박했음을 알려주기 위해 pinkSub 컬러 적용
                self.mypagePlantWateringDdayLabel.textColor = .pinkSub
                dayCornerView.layer.borderColor = pinkSub
            }
            self.mypagePlantWateringDdayLabel.text = "D-\(wateringDay)"
            self.mypagePlantWateringDdayLabel.textColor = .seaweed
            dayCornerView.layer.borderColor = seaweed
        }
    }
    
}
