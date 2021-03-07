//
//  SplashVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/15.
//

import UIKit

class SplashVC: UIViewController {

    @IBOutlet var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
       super.viewDidAppear(animated)

       self.view.layoutIfNeeded()
       self.logoImageView.alpha = 0.0

        UIView.animate(withDuration: 3.0, animations:
       {
           self.logoImageView.alpha = 1.0
           self.view.layoutIfNeeded()
       },completion: {finished in
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let vc = (self.storyboard?.instantiateViewController(identifier: "LoginVC"))! as LoginVC
            
            self.navigationController?.pushViewController(vc, animated: false)
        }
       })
    }
}