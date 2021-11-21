//
//  NumPadBtn.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/12.
//

import UIKit
import Then

final class NumPadBtn: UIButton {
    var numPadDeleagate: NumPadDelegate?
    
    init(title: String?) {
        super.init(frame: .zero)
        if let title = title {
            self.setButton(title: title, size: 24, weight: .medium)
        } else {
            self.setImage(UIImage(named: "btnDeleteSelected"), for: .normal)
        }
        self.addTarget(self, action: #selector(tapPad), for: .touchDown)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    func tapPad() {
        if let title = self.titleLabel?.text {
            switch title {
            case "0":
                numPadDeleagate?.receiveAction(number: 0)
            case "1":
                numPadDeleagate?.receiveAction(number: 1)
            case "2":
                numPadDeleagate?.receiveAction(number: 2)
            case "3":
                numPadDeleagate?.receiveAction(number: 3)
            case "4":
                numPadDeleagate?.receiveAction(number: 4)
            case "5":
                numPadDeleagate?.receiveAction(number: 5)
            case "6":
                numPadDeleagate?.receiveAction(number: 6)
            case "7":
                numPadDeleagate?.receiveAction(number: 7)
            case "8":
                numPadDeleagate?.receiveAction(number: 8)
            case "9":
                numPadDeleagate?.receiveAction(number: 9)
            default:
                break
            }
        } else {
            numPadDeleagate?.receiveAction(number: nil)
        }
    }
}

protocol NumPadDelegate {
    func receiveAction(number: Int?)
}
