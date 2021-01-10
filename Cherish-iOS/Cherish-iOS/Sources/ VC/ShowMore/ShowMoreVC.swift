//
//  ShowMoreVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/02.
//

import UIKit

class ShowMoreVC: UIViewController {

    @IBOutlet weak var topNaviBar: UIView!{
        didSet{
            topNaviBar.dropShadow(color: .showmoreShadow, offSet: CGSize(width: 0, height: 1), opacity: 0.7, radius: 0)
        }
    }
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var showMoreTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        showMoreTableView.tableHeaderView = HeaderView
        // Do any additional setup after loading the view.
    }
}

extension ShowMoreVC: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        <#code#>
    }
    
    
}
