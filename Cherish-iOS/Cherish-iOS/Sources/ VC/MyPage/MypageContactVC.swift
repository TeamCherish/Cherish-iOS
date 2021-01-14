//
//  MypageContactVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit

class MypageContactVC: UIViewController {

    @IBOutlet var mypageContactTV: MyOwnTableView!
    var mypageContactArray: [Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
        setContactData()
        mypageContactTV.delegate = self
        mypageContactTV.dataSource = self
        mypageContactTV.separatorStyle = .none
    }
    
    func setContactData(){
        if let data = UserDefaults.standard.value(forKey: "userContacts") as? Data {
            let contacts = try? PropertyListDecoder().decode([Friend].self, from: data)

            mypageContactArray = contacts!
            print(mypageContactArray)
        }
    }
}

extension MypageContactVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mypageContactArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MypageContactTVC") as! MypageContactTVC
        
        cell.setProperties(mypageContactArray[indexPath.row].name, mypageContactArray[indexPath.row].phoneNumber)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}
