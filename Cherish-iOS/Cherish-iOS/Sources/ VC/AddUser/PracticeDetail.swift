//
//  PracticeDetail.swift
//  Cherish-iOS
//
//  Created by 장서현 on 2021/01/07.
//

import UIKit

class PracticeDetail: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var data = ["사과", "오렌지", "배" ,"바나나", "장서현"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.dataSource = self
//        tableView.delegate = self
        setSearchBar()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    func setSearchBar(){
        searchBar.placeholder = "친구 검색"
        searchBar.setImage(UIImage(named: "icn_search_box"), for: UISearchBar.Icon.search, state: .normal)
        searchBar.setSearchFieldBackgroundImage(UIImage(named: "search_box"), for: .normal)
    }
}

extension PracticeDetail: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PracticeCell.identifier) as? PracticeCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}

