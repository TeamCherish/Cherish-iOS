//
//  CircularProgressView.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/04.
//

import UIKit

class CircularProgressView: UIView {
    
    fileprivate var progressLayer = CAShapeLayer()
        fileprivate var trackLayer = CAShapeLayer()
        
        /*
        // Only override draw() if you perform custom drawing.
        // An empty implementation adversely affects performance during animation.
        override func draw(_ rect: CGRect) {
            // Drawing code
        }
        */
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            createCircularPath()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            createCircularPath()
        }
        
        var progressColor = UIColor.white {
            didSet {
                progressLayer.strokeColor = progressColor.cgColor
            }
        }
        
        var trackColor = UIColor.white {
            didSet {
                trackLayer.strokeColor = trackColor.cgColor
            }
        }
        
        fileprivate func createCircularPath() {
            /// ScreenSize 가져오는 변수들
            let screenWidth = UIScreen.main.bounds.size.width
            let screenHeight = UIScreen.main.bounds.size.height
            
            if screenWidth == 375 && screenHeight == 667 {
                print("아이폰 8 이에요")
                self.frame.size = CGSize(width: 118, height: 118)
            }
            if screenWidth == 428 && screenHeight == 926 {
                print("아이폰 12 Pro Max 이에요")
                self.frame.size = CGSize(width: 180, height: 180)
            }
            if screenWidth == 414 && screenHeight == 896 {
                print("아이폰 11 Pro Max 이에요")
                self.frame.size = CGSize(width: 168, height: 168)
            }
            if screenWidth == 414 && screenHeight == 736 {
                print("아이폰 8+ 이에요")
                self.frame.size = CGSize(width: 148, height: 148)
            }
            self.backgroundColor = UIColor.clear
            self.layer.cornerRadius = self.frame.size.width/2
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width - 1.5)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
            trackLayer.path = circlePath.cgPath
            trackLayer.fillColor = UIColor.clear.cgColor
            trackLayer.strokeColor = trackColor.cgColor
            trackLayer.lineWidth = 7.0
            trackLayer.strokeEnd = 1.0
            layer.addSublayer(trackLayer)
            
            progressLayer.path = circlePath.cgPath
            progressLayer.fillColor = UIColor.clear.cgColor
            progressLayer.strokeColor = progressColor.cgColor
            progressLayer.lineWidth = 7.0
            progressLayer.strokeEnd = 0.0
            progressLayer.lineCap = .round
            layer.addSublayer(progressLayer)
        }
        
        func setProgressWithAnimation(duration: TimeInterval, value: Float) {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.duration = duration
            animation.fromValue = 0
            animation.toValue = value
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            progressLayer.strokeEnd = CGFloat(value)
            progressLayer.add(animation, forKey: "animateprogress")
        }
}
