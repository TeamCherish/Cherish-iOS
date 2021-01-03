//
//  PopUpContact.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class PopUpContact: UIViewController {

    @IBOutlet weak var popupContactView: UIView!{
        didSet{
            popupContactView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var contactNameLabel: CustomLabel!{
        didSet{
            contactNameLabel.textColor = .black
        }
    }
    @IBOutlet weak var contactConversationLabel: CustomLabel!{
        didSet{
            contactConversationLabel.textColor = .black
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
