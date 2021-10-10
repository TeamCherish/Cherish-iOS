//
//  UIFont+.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit

enum FontWeight {
    case light, regular, medium, bold
}

extension UIFont {
    // MARK: NotoSansCJKkr Font
    class func notoLight(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Light", size: size)!
    }
    
    class func notoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Regular", size: size)!
    }
    
    class func notoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Medium", size: size)!
    }
    
    class func notoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "NotoSansCJKkr-Bold", size: size)!
    }
    
    // MARK: Roboto Font    
    class func robotoRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    class func robotoMedium(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    class func robotoBold(size: CGFloat) -> UIFont {
        return UIFont(name: "Roboto-Bold", size: size)!
    }
}
