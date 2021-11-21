//
//  LeafModel.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/12.
//

import UIKit

struct LeafModel {
    var isActivated: Bool {
        didSet {
            self.imgName = self.isActivated ? "icSetPasswordSelected" : "icSetPassword"
        }
    }
    var imgName: String = "icSetPassword" {
        didSet {
            self.imgView.image = UIImage(named: self.imgName)
        }
    }
    var imgView: UIImageView = UIImageView.init(image: UIImage(named: "icSetPassword"))
}
