//
//  UIButton+Extention.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/08.
//

import UIKit

extension UIButton {
    
    // FIXME: 전부 코드 베이스로 변경되는 순간이 오면 삭제
    @IBInspectable
    var letterSpacing: CGFloat {
        set {
            let attributedString: NSMutableAttributedString
            if let currentAttrString = attributedTitle(for: .normal) {
                attributedString = NSMutableAttributedString(attributedString: currentAttrString)
            }
            else {
                attributedString = NSMutableAttributedString(string: self.title(for: .normal) ?? "")
                setTitle(.none, for: .normal)
            }
            
            attributedString.addAttribute(NSAttributedString.Key.kern, value: newValue, range: NSRange(location: 0, length: attributedString.length))
            setAttributedTitle(attributedString, for: .normal)
        }
        get {
            if let currentLetterSpace = attributedTitle(for: .normal)?.attribute(NSAttributedString.Key.kern, at: 0, effectiveRange: .none) as? CGFloat {
                return currentLetterSpace
            }
            else {
                return 0
            }
        }
    }
    
    /// 버튼 기본 셋팅 변경, 폰트 사이즈 adjusted 적용되어 있음
    func setButton(bgColor: UIColor = .systemBackground, textColor: UIColor = .black, title: String, size: CGFloat, weight: FontWeight = .regular) {
        let font: UIFont
        
        switch weight {
        case .light:
            font = .notoLight(size: size.adjusted)
        case .regular:
            font = .notoRegular(size: size.adjusted)
        case .medium:
            font = .notoMedium(size: size.adjusted)
        case .bold:
            font = .notoBold(size: size.adjusted)
        }
        
        self.titleLabel?.font = font
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
        self.setTitle(title, for: .normal)
    }
    
    /// 버튼 배경색, 글씨 색 변경
    func changeColors(bgColor: UIColor, textColor: UIColor) {
        self.backgroundColor = bgColor
        self.setTitleColor(textColor, for: .normal)
    }
    
    
    /// button의 기본, 클릭 이미지를 빠르게 설정
    func setImageByName(name: String, selectedName: String?) {
        self.setImage(UIImage(named: name), for: .normal)
        if let selected = selectedName {
            self.setImage(UIImage(named: selected), for: .selected)
        }
    }
    
    /**
     - Description:
     button에 대해 addTarget해서 일일이 처리안하고, closure 형태로 동작을 처리하기 위해 다음과 같은 extension을 활용합니다
     press를 작성하고, 안에 버튼이 눌렸을 때, 동작하는 함수를 만듭니다.
     
     clicked(completion : @escaping ((Bool) -> Void)) 함수를 활용해,
     버튼이 눌렸을때, 줄어들었다가 다시 늘어나는 (Popping)효과를 추가해서
     사용자에게 버튼이 눌렸다는 인터렉션을 제공합니다!
     
     진동은 선택 가능하게 바꾸었습니다.
     */
    
    // iOS14부터는 UIAction의 addAction이 가능
    // iOS13까지는 NSObject형태로 등록해서 처리하는 방식으로 분기처리
    func press(vibrate: Bool = false, for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        if #available(iOS 14.0, *) {
            self.addAction(UIAction { (action: UIAction) in closure()
                self.clickedAnimation(vibrate: vibrate)
            }, for: controlEvents)
        } else {
            @objc class ClosureSleeve: NSObject {
                let closure:()->()
                init(_ closure: @escaping()->()) { self.closure = closure }
                @objc func invoke() { closure() }
            }
            let sleeve = ClosureSleeve(closure)
            self.addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
            objc_setAssociatedObject(self, "\(UUID())", sleeve, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        
    }
    
    /**
     - Description:
     해당 함수를 통해서 Poppin 효과를 처리합니다. 줄어드는 정도를 조절하고싶다면 ,ScaleX,Y값을 조절합니다(최대값 1).
     낮을수록 많이 줄어듦.
     */
    func clickedAnimation(vibrate: Bool) {
        if vibrate { makeVibrate(degree: .light) }
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95) }, completion: { (finish: Bool) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.transform = CGAffineTransform.identity
                })
            }
        )
    }
}
