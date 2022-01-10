//
//  NoPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class AddUserVC: BaseController {

    @IBOutlet weak var addBtn: UIButton!{
        didSet{
            addBtn.backgroundColor = .seaweed
            addBtn.makeRounded(cornerRadius: 25.0)
            addBtn.isEnabled = true
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefaults.standard.set(false, forKey: "isPlantExist")
    }    
    
    @IBAction func touchUpToAddNC(_ sender: UIButton) {
        print("hello")
        if let vc = self.storyboard?.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
//            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
