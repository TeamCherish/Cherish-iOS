//
//  PlantExplainCVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/04.
//

import UIKit
import Lottie

class PlantExplainCVC: UICollectionViewCell {
    
    @IBOutlet var plantExplainTitleLabel: CustomLabel!
    @IBOutlet var plantExplainSubtitleLabel: CustomLabel!
    @IBOutlet var plantImageView: UIImageView!
    @IBOutlet var flowerMeaningImageView: UIImageView!
    
    //MARK: - collectionviewcell 재사용 할 때 셀을 초기화해줌
    // 만일 스크롤을 통해 하나의 Cell이 화면에서 사라지고 그 Cell이 새로운 Cell을 위해 재사용이 되는데 사라진 Cell에 해당하는 종목은 사용자가 보유하여 보유량이 표현이 된다.
    // 새로 생길 Cell에 해당하는 종목은 보유하고 있지 않으면 보유량을 표시해주지 말아야 하지만 Custom Cell을 디자인할 때는 보유량의 유무와 상관없이 UILabel을 올리기 때문에 사용자가 보유하고 있는 사라진 Cell의 보유량이 새로 보일 사용자가 보유하고 있지 않는 Cell에 그대로 나타나게 된다.
    //따라서 prepareForReuse함수를 사용해서 재사용할 때 셀에 데이터를 넣기 전에 셀을 초기화해줌으로써 재사용됨으로 인해 생기는 중복문제를 막는다.
    
    
    override func prepareForReuse() {
        self.plantExplainTitleLabel.text = ""
        self.plantExplainSubtitleLabel.text = ""
        self.plantImageView.image = UIImage()
        self.flowerMeaningImageView.image = UIImage()
    }
    
}
