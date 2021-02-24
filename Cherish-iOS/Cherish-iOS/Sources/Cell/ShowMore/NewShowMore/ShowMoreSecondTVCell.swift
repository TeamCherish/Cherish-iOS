//
//  ShowMoreSecondTVCell.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/23.
//

import UIKit

class ShowMoreSecondTVCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var pushAlarmSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        resizeUISwitch()
        setAlarmSwitchStatus()
    }
    
    func resizeUISwitch() {
        pushAlarmSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
    }
    
    /// 첫 로드 시 사용자의 푸시알람 승인 상태에 따른 스위치 값 set
    func setAlarmSwitchStatus() {
        let current = UNUserNotificationCenter.current()
        
        current.getNotificationSettings(completionHandler: { [self] (settings) in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    pushAlarmSwitch.isOn = false
                    print("notDetermined")
                }
            } else if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    pushAlarmSwitch.isOn = false
                    print("denied")
                }
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    pushAlarmSwitch.isOn = true
                    print("authorized")
                }
            }
        })
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
