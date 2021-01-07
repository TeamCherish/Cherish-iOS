//
//  Utils.swift
//  ProfileView
//
//  Created by eduardo rodríguez on 04/05/2020.
//  Copyright © 2020 Eduardo Rodríguez Pérez. All rights reserved.
//

import UIKit

class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class ReselectableSegmentedControl: UISegmentedControl {
    override var next: UIResponder? {
        get {
            var view: UIScrollView?
            for v in self.superview!.superview!.subviews {
                if v is UIScrollView{
                    view = v as! UIScrollView
                }
            }
            return view?.subviews[0]
        }
    }
}

class HeaderButton: UIButton {
}

class MyOwnTableView: UITableView {
    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return self.contentSize
    }

    override var contentSize: CGSize {
        didSet{
            self.invalidateIntrinsicContentSize()
        }
    }

    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
    }
}
