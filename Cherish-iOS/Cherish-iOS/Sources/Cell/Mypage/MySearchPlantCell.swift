//
//  MySearchPlantCell.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/02/22.
//

import UIKit

class MySearchPlantCell: UITableViewCell {
    
    @IBOutlet weak var myPlantImg: UIImageView!
    @IBOutlet weak var myPlantNickname: CustomLabel!
    @IBOutlet weak var myPlantType: CustomLabel!
    @IBOutlet weak var myPlantWateringDday: CustomLabel!
    @IBOutlet weak var dayCornerView: UIView!
    
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
    
    
    func makeRadiusView() {
        dayCornerView.layer.borderWidth = 1.15
        dayCornerView.layer.cornerRadius = 13
    }
    
    func setProperties(_ imageData:Data, _ nickname:String,_ plantType:String,_ wateringDay:Int){
        myPlantImg.image = UIImage(data: imageData)
        myPlantNickname.text = nickname
        myPlantType.text = plantType
        
        /// dDay 값 파싱 -,+,0
        // dDay가 0일 때
        if wateringDay == 0 {
            self.myPlantWateringDday.text = "D-day"
            self.myPlantWateringDday.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        // dDay가 0 이하일 때 (D+)
        else if wateringDay < 0 {
            self.myPlantWateringDday.text = "D+\(-wateringDay)"
            self.myPlantWateringDday.textColor = .pinkSub
            dayCornerView.layer.borderColor = pinkSub
        }
        // dDay가 0 초과일 때 (D+)
        else {
            // dDay가 1일 때만
            if wateringDay == 1 {
                // 메인뷰에서 적용되는 물 아이콘이 표시되는 기준에 맞춰
                // 물주기가 임박했음을 알려주기 위해 pinkSub 컬러 적용
                self.myPlantWateringDday.textColor = .pinkSub
                dayCornerView.layer.borderColor = pinkSub
            }
            self.myPlantWateringDday.text = "D-\(wateringDay)"
            self.myPlantWateringDday.textColor = .seaweed
            dayCornerView.layer.borderColor = seaweed
        }
    }

}
