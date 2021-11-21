//
//  ShowMoreCell.swift
//  Cherish-iOS
//
//  Created by Wonseok Lee on 2021/11/08.
//

import UIKit
import SnapKit
import Then

final class ShowMoreCell: UITableViewCell {
    
    // MARK: UI
    
    private lazy var cellLabel = UILabel().then {
        $0.setLabel(text: "cherish", size: 15, weight: .medium)
    }
    private lazy var goBtn = UIButton().then {
        $0.setImage(UIImage(named: "icBtnMore"), for: .normal)
    }
    private (set) lazy var toggleSwitch = UISwitch()
    
    // MARK: Variables
    
    enum CellSection {
        case btn, toggle, none
    }
    
    var section: CellSection = .none
    
    var showMoreDelegate: ShowMoreSwitchDelegate?
    
    // MARK: Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.setLayout(section)
        self.toggleSwitch.addTarget(self, action: #selector(onClickSwitch), for: UIControl.Event.valueChanged)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.cellLabel.text?.removeAll()
    }
}

// MARK: Extensions

extension ShowMoreCell {
    
    // MARK: Private Functions
    
    private func setLayout(_ section: CellSection) {
        setLabelLayout()
        switch section {
        case .btn:
            setGoBtnLayout()
        case .toggle:
            setSwitchLayout()
        case .none:
            self.cellLabel.textColor = .pinkSub
        }
    }
    
    private func setLabelLayout() {
        self.contentView.add(cellLabel) {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(23)
            }
        }
    }
    
    private func setGoBtnLayout() {
        self.contentView.add(goBtn) {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(25)
            }
        }
    }
    
    private func setSwitchLayout() {
        self.contentView.add(toggleSwitch) {
            $0.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.right.equalToSuperview().inset(21)
                $0.height.equalTo(self.cellLabel)
            }
        }
    }
    
    @objc func onClickSwitch() {
        showMoreDelegate?.switchAction(sender: self.toggleSwitch, idx: self.getTableCellIndexPath())
    }
    
    // MARK: Public Functions
    
    func setData(_ title: String) {
        self.cellLabel.text = title
    }
    
}


// MARK: Protocol

protocol ShowMoreSwitchDelegate {
    func switchAction(sender: UISwitch, idx: Int)
}
