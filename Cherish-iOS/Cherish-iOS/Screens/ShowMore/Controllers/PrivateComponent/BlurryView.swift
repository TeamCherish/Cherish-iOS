//
//  BlurryView.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/12/07.
//

import UIKit
import SnapKit
import Then

final class BlurryView: UIView {

    // MARK: UI Components
    private lazy var blurEffect = UIBlurEffect(style: .light)
    private lazy var visualEffectView = UIVisualEffectView(effect: blurEffect)
    private lazy var logo = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "cherishLogoPlant")
    }
    
    // MARK: Initializing
    init(viewTag: Int) {
        super.init(frame: UIScreen.main.bounds)
        self.tag = viewTag
        self.backgroundColor = .clear
        setLayout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Layout
    private func setLayout() {
        self.adds([visualEffectView, logo]) {
            $0[0].snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            $0[1].snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
}
