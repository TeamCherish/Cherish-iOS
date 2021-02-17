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
            
            // 숫자 -> 한글 가나다순 -> 영어순으로 정렬
            mypageContactArray = mypageContactArray.sorted(by: {$0.name.localizedStandardCompare($1.name) == .orderedAscending })
            // 숫자로 시작하는 문자열 추출 후 저장
            let startNumberArray = mypageContactArray.filter{$0.name.first?.isNumber == true}
            // 문자로 시작하는 문자열만 추출해서 저장
            mypageContactArray = mypageContactArray.filter{$0.name.first?.isNumber == false}
            // 문자로 시작하는 문자열 뒤에 숫자로 시작하는 문자열 병합
            mypageContactArray.append(contentsOf: startNumberArray)

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
