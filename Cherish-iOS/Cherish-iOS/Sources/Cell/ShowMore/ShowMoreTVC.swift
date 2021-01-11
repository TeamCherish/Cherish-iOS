//
//  ShowMoreTVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/11.
//

import UIKit

class ShowMoreTVC: UITableViewCell {
    static let identifier = "ShowMoreTVC"
    
    @IBOutlet weak var showMoreImageView: UIImageView!
    @IBOutlet weak var showMoreName: UILabel!
    
    static func nib() -> UINib {
        return UINib(nibName: "ShowMoreTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setImageCell(imageName: String, labelName: String){
        self.showMoreImageView.image = UIImage(named: imageName)
        self.showMoreName.text = labelName
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
