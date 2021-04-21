//
//  OpenSourcesVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/04/21.
//

import UIKit

class OpenSourcesVC: UIViewController {

    @IBOutlet var openSourceInfoTV: UITableView!
    var openSourceArray:[String] = ["Alamofire", "Kingfisher", "FSCalendar", "OverlayContainer", "Firebase"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegates()
        addNavigationSwipeGuesture()
    }
    
    func setDelegates() {
        openSourceInfoTV.delegate = self
        openSourceInfoTV.dataSource = self
        openSourceInfoTV.separatorStyle = .none
    }
    
    //MARK: - add Swipe Guesture that go back to parentVC
    func addNavigationSwipeGuesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }

    @IBAction func touchUpToBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension OpenSourcesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return openSourceArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSourcesTVCell") as! OpenSourcesTVCell
        cell.openSourceNameLabel.text = openSourceArray[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }
}
