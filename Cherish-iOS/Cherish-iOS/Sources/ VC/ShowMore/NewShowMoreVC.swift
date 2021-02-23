//
//  NewShowMoreVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/23.
//

import UIKit

class NewShowMoreVC: UIViewController {

    @IBOutlet var showMoreTV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        // Do any additional setup after loading the view.
    }
    
    func setDelegates() {
        showMoreTV.delegate = self
        showMoreTV.dataSource = self
    }
}

extension NewShowMoreVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
    
}
