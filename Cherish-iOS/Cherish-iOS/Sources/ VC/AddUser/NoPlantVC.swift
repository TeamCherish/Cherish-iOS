//
//  NoPlantVC.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/15.
//

import UIKit

class NoPlantVC: UIViewController {

    @IBOutlet weak var addBtn: UIButton!{
        didSet{
            addBtn.backgroundColor = .seaweed
            addBtn.makeRounded(cornerRadius: 25.0)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else {return}
        setFirstVC()
        // Do any additional setup after loading the view.

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func setFirstVC() {
        let vc = (self.storyboard?.instantiateViewController(identifier: "NoPlantVC"))! as NoPlantVC
        
        // 스플래시 후 CherishMainVC로 push를 하고나서 루트 뷰컨을 CherishMainVC로 변경해줌
        // --> 홈탭이 눌려도 스플래시뷰로 이동되지 않게 아예 루트뷰컨을 변경한 것임
        self.navigationController?.setViewControllers([vc], animated: false)
    }
    
    
    @IBAction func touchUpToAddNC(_ sender: UIButton) {
        guard let dvc = self.storyboard?.instantiateViewController(identifier: "PlantResultVC") as? PlantResultVC else {return}
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "SelectFriendSearchBar") as? SelectFriendSearchBar {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
