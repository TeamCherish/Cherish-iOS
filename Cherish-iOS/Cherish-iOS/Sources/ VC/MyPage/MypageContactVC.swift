//
//  MypageContactVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/07.
//

import UIKit
import Contacts

class MypageContactVC: UIViewController {

    @IBOutlet var mypageContactTV: MyOwnTableView!
    var mypageContactArray: [Friend] = []
    
    var deviceContacts = [FetchedContact]()
    var fetchedName:[String] = []
    var cherishContacts:[Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.translatesAutoresizingMaskIntoConstraints = false
//        setContactData()
        checkContactArray()
        requestAccess(completionHandler: {_ in })
        mypageContactTV.delegate = self
        mypageContactTV.dataSource = self
        mypageContactTV.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        requestAccess(completionHandler: {_ in })
    }
    
    
    //MARK: - 체리쉬 앱 연락처 동기화 여부 검사 함수
    func requestAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let store = CNContactStore()
        switch CNContactStore.authorizationStatus(for: .contacts) {
        case .authorized:
            completionHandler(true)
        case .denied:
            UserDefaults.standard.set([], forKey: "userContacts")
            mypageContactTV.reloadData()
            showSettingsAlert(completionHandler)
        case .restricted, .notDetermined:
            store.requestAccess(for: .contacts) { granted, error in
                if granted {
                    completionHandler(true)
                } else {
                    DispatchQueue.main.async { [self] in
                        UserDefaults.standard.set([], forKey: "userContacts")
                        mypageContactTV.reloadData()
                        self.showSettingsAlert(completionHandler)
                    }
                }
            }
        @unknown default:
            fatalError()
        }
    }
    
    //MARK: - 체리쉬 앱 연락처 동기화 설정 거부했을 때 뜨는 알림창
    private func showSettingsAlert(_ completionHandler: @escaping (_ accessGranted: Bool) -> Void) {
        let alert = UIAlertController(title: "다음 작업을 위해 Cherish가 사용자의 연락처에 접근하는 것을 허용합니다.", message: "*Cherish에 휴대폰의 연락처를 동기화", preferredStyle: .alert)
        if
            let settings = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settings) {
                alert.addAction(UIAlertAction(title: "설정 열기", style: .default) { action in
                    completionHandler(false)
                    UIApplication.shared.open(settings)
                })
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel) { action in
            self.tabBarController?.selectedIndex = 0
            completionHandler(false)
        })
        present(alert, animated: true)
    }
    
    //MARK: - 체리쉬 앱 연락처를 가져오는 함수
    func checkContactArray() {
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [self] (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                /// 2. a CNContactFetchRequest object is created containing the name and telephone keys .
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3. All contacts are fetched with the request, the corresponding keys are assigned to the property of the FetchContact object and added to the contacts array.
                    try store.enumerateContacts(with: request, usingBlock: { [self] (contact, stopPointer) in
                        deviceContacts.append(FetchedContact(fristName: contact.givenName, lastName: contact.familyName, telephone: contact.phoneNumbers.first?.value.stringValue ?? ""))
                    })
                    print("저장?")
                    makeCherishContacts()
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                UserDefaults.standard.set([], forKey: "userContacts")
                mypageContactTV.reloadData()
                print("access denied")
            }
        }
    }
    
    //MARK: - 체리쉬 앱 연락처 동기화 후 이름 형식 맞게 파싱한 데이터 저장함수
    func makeCherishContacts() {
        
        switch CNContactStore.authorizationStatus(for: .contacts) {
        /// 권한을 허용했을 때
        case .authorized:
            // 이름 합치기
            for i in 0...deviceContacts.count - 1 {
                fetchedName.append((deviceContacts[i].lastName)+(deviceContacts[i].fristName))
                deviceContacts[i].telephone = deviceContacts[i].telephone.components(separatedBy: ["-","/","/"]).joined()
                
                self.cherishContacts.append(contentsOf: [
                    Friend(name: fetchedName[i], phoneNumber: deviceContacts[i].telephone, selected: false)
                ])
            }
            UserDefaults.standard.set(try? PropertyListEncoder().encode(cherishContacts), forKey: "userContacts")
            setContactData()
            
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        }
        
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
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
}
