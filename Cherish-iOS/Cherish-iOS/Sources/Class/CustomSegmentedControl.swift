//
//  CustomSegmentedControl.swift
//
//
//  Created by Bruno Faganello on 05/07/18.
//  Copyright © 2018 Code With Coffe . All rights reserved.
//

import UIKit
protocol CustomSegmentedControlDelegate:class {
    func change(to index:Int)
}

class CustomSegmentedControl: UIView {
    private var buttonTitles:[String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!

    var textColor:UIColor = .black
    var selectorViewColor: UIColor = .red
    var selectorTextColor: UIColor = .red

    weak var delegate:CustomSegmentedControlDelegate?

    public private(set) var selectedIndex : Int = 0

    convenience init(frame:CGRect,buttonTitle:[String]) {
        print("convenience")
        self.init(frame: frame)
        self.buttonTitles = buttonTitle
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor.white
        updateView()
        print("draw")
    }

    func setButtonTitles(buttonTitles:[String]) {
        print("setButtonTitles")
        self.buttonTitles = buttonTitles
        self.updateView()
    }

    func setIndex(index:Int) {
        print("setIndex")
        buttons.forEach({ $0.setTitleColor(.textGrey, for: .normal) })
        buttons.forEach({ $0.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)})
        let button = buttons[index]
        selectedIndex = index
        button.setTitleColor(selectorTextColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
        UIView.animate(withDuration: 0.2) {
            self.selectorView.frame.origin.x = selectorPosition
        }
    }

    @objc func buttonAction(sender:UIButton) {
        print("buttonAction")
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(.textGrey, for: .normal)
            btn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
            if btn == sender {
                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                selectedIndex = buttonIndex
                delegate?.change(to: selectedIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
                btn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
            }
        }
    }
}

//Configuration View
extension CustomSegmentedControl {
    private func updateView() {
        createButton()
        configSelectorView()
        configStackView()
    }

    private func configStackView() {
        print("configStackView")
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    private func configSelectorView() {
        print("configSelectorView")
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }

    private func createButton() {
        print("createButton")
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach({$0.removeFromSuperview()})

        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(.textGrey, for: .normal)
            button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
        buttons[0].titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
    }
}

//import UIKit
//protocol CustomSegmentedControlDelegate:class {
//    func change(to index:Int)
//}
//
//class CustomSegmentedControl: UIView {
//    private var buttonTitles:[String]!
//    private var buttons: [UIButton]!
//    private var selectorView: UIView!
//    // 숫자 초록색으로 할 때 필요한 변수
//    private var btnTitles:[NSMutableAttributedString]!
//    // 일단 테스트용 분기처리
//    private var check : Int = 0
//
//    var textColor:UIColor = .black
//    var selectorViewColor: UIColor = .red
//    var selectorTextColor: UIColor = .red
//
//    weak var delegate:CustomSegmentedControlDelegate?
//
//    public private(set) var selectedIndex : Int = 0
//
//    convenience init(frame:CGRect,buttonTitle:[String]) {
//        self.init(frame: frame)
//        self.buttonTitles = buttonTitle
//    }
//
//    override func draw(_ rect: CGRect) {
//        super.draw(rect)
//        self.backgroundColor = UIColor.white
//        updateView()
//    }
//
//    func setButtonTitles(buttonTitles:[String]) {
//        self.buttonTitles = buttonTitles
//        self.updateView()
//    }
//
//    // 숫자는 초록색으로다가
//    func setBtnTitles(buttonTitles :[NSMutableAttributedString]) {
//        self.check = 1
//        self.btnTitles = buttonTitles
//        self.updateView()
//    }
//
//    func setIndex(index:Int) {
//        print("setIndex")
//        buttons.forEach({ $0.setTitleColor(.textGrey, for: .normal) })
//        buttons.forEach({ $0.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)})
//        let button = buttons[index]
//        selectedIndex = index
//        button.setTitleColor(selectorTextColor, for: .normal)
//        button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
//        // 원래는 얘다
////        let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(index)
//        let selectorPosition = frame.width/CGFloat(2) * CGFloat(index)
//        UIView.animate(withDuration: 0.2) {
//            self.selectorView.frame.origin.x = selectorPosition
//        }
//    }
//
//    @objc func buttonAction(sender:UIButton) {
//        for (buttonIndex, btn) in buttons.enumerated() {
//            btn.setTitleColor(.textGrey, for: .normal)
//            btn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
//            if btn == sender {
//                // 원래는 얘야
////                let selectorPosition = frame.width/CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
//                let selectorPosition = frame.width/CGFloat(2) * CGFloat(buttonIndex)
//                selectedIndex = buttonIndex
//                delegate?.change(to: selectedIndex)
//                UIView.animate(withDuration: 0.3) {
//                    self.selectorView.frame.origin.x = selectorPosition
//                }
//                btn.setTitleColor(selectorTextColor, for: .normal)
//                btn.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
//            }
//        }
//    }
//}
//
////Configuration View
//extension CustomSegmentedControl {
//    private func updateView() {
//        createButton()
//        configSelectorView()
//        configStackView()
//    }
//
//    private func configStackView() {
//        let stack = UIStackView(arrangedSubviews: buttons)
//        stack.axis = .horizontal
//        stack.alignment = .fill
//        stack.distribution = .fillEqually
//        addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
//        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
//    }
//
//    private func configSelectorView() {
////        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
//        // 분기처리 내가 테스트해보려고
//        var selectorWidth : CGFloat
//        if check == 0 {
//            selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
//        }
//        else {
//            selectorWidth = frame.width / CGFloat(self.btnTitles.count)
//        }
//        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
//        selectorView.backgroundColor = selectorViewColor
//        addSubview(selectorView)
//    }
//
//    private func createButton() {
//        buttons = [UIButton]()
//        buttons.removeAll()
//        subviews.forEach({$0.removeFromSuperview()})
//
//        // 얘가 원래 있던 자식
////        for buttonTitle in buttonTitles {
////            let button = UIButton(type: .system)
////            button.setTitle(buttonTitle, for: .normal)
////            button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
////            button.setTitleColor(.textGrey, for: .normal)
////            button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
////            buttons.append(button)
////        }
//
//        // 테스트용으로 분기처리 추가해볼게
//        if check == 0 {
//            for buttonTitle in buttonTitles {
//                let button = UIButton(type: .system)
//                button.setTitle(buttonTitle, for: .normal)
//                button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
//                button.setTitleColor(.textGrey, for: .normal)
//                button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
//                buttons.append(button)
//            }
//        }
//        else {
//            // 여기 내가 추가해본거
//            for buttonTitle in btnTitles {
//                let button = UIButton(type: .system)
//                button.setAttributedTitle(buttonTitle, for: .normal)
//                button.addTarget(self, action:#selector(CustomSegmentedControl.buttonAction(sender:)), for: .touchUpInside)
//                button.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Medium", size: 16)
//                buttons.append(button)
//            }
//        }
//        buttons[0].setTitleColor(selectorTextColor, for: .normal)
//        buttons[0].titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 16)
//    }
//
//
//}
