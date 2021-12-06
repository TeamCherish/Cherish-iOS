//
//  BackNaviView.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/10/09.
//

import UIKit
import SnapKit

/**
 - Description:
 우리가 기본 네비바 말고 커스텀해서 사용하는 곳이 많아서 만들어놓았습니다.
 뒤로가기 버튼이랑 타이틀로 구성된 UIView이고, backBtn의 동작은 UIButton+Extension의 press를
 활용해서 처리하면 편해요
 
 - Note:
 setTitle: title을 설정하면 naviBar 중앙에 위치하는 라벨이 표시 됩니다.
 */
class BackNaviView: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.setLabel(text: "제목", color: .cherishBlack, size: 16, weight: .medium)
    }
    private (set) lazy var backBtn = UIButton().then {
        $0.setImageByName(name: "icnBack", selectedName: nil)
        $0.contentMode = .scaleAspectFit
    }
    
    init() {
        super.init(frame: .zero)
        setDefaultStyle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setDefaultStyle()
    }

    
    private func setDefaultStyle() {
        self.adds([backBtn, titleLabel]) {
            $0[0].snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.top.left.bottom.equalToSuperview()
            }
            
            $0[1].snp.makeConstraints {
                $0.centerX.centerY.equalToSuperview()
            }
        }
    }
    
    // MARK: Methods
    /// 커스텀 네비 바 중앙 타이틀 설정
    func setTitleLabel(title: String) {
        self.titleLabel.text = title
    }
}
