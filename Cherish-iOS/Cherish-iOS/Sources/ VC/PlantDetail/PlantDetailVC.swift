//
//  PlantDetailVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/03.
//

import UIKit

class PlantDetailVC: UIViewController {

    @IBOutlet var plantCircularProgressView: CircularProgressBar!
    @IBOutlet var firstMemoView: UIView!
    @IBOutlet var secondMemoVIew: UIView!
    @IBOutlet var wateringBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeCircularView()
        makeCornerRadiusView()
        // Do any additional setup after loading the view.
    }
    
    func makeCircularView(){
        plantCircularProgressView.lineWidth = 7
        plantCircularProgressView.lineBackgroundColor = .seaweed
    }
    
    func makeCornerRadiusView(){
        firstMemoView.layer.cornerRadius = 15
        secondMemoVIew.layer.cornerRadius = 15
        wateringBtn.layer.cornerRadius = 25
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
