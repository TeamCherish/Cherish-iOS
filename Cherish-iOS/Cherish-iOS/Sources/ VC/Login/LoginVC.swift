//
//  LoginVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/01/08.
//

import UIKit
import Contacts

class LoginVC: UIViewController {
    
    @IBOutlet var loginEmailTextField: UITextField!
    @IBOutlet var loginPwTextField: UITextField!
    @IBOutlet var cancelEmailTextingBtn: UIButton!
    @IBOutlet var cancelPwTextingBtn: UIButton!
    @IBOutlet var findEmailBtn: UIButton!
    @IBOutlet var findPwBtn: UIButton!
    @IBOutlet var signUpBtn: UIButton!
    @IBOutlet var logoImageView: UIImageView!
    
    var deviceContacts = [FetchedContact]()
    var fetchedName:[String] = []
    var cherishContacts:[Friend] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeDelegate()
        makeTextFieldLeftPadding()
        setTextFieldBackgroud()
        cancelBtnNotVisible()
        textFieldEditingCheck()
        setButtonTextKerns(-0.7)
        fetchContacts()
        keyboardObserver()
    }
    
    
    func makeDelegate() {
        loginEmailTextField.delegate = self
        loginPwTextField.delegate = self
    }
    
    // cancel 버튼 처음 visible 상태를 false로
    func cancelBtnNotVisible() {
        cancelEmailTextingBtn.isHidden = true
        cancelPwTextingBtn.isHidden = true
    }
    
    // set textField background Image
    func setTextFieldBackgroud() {
        loginEmailTextField.background = UIImage(named: "loginInput")
        loginPwTextField.background = UIImage(named: "loginInput")
        loginEmailTextField.layer.borderWidth = 0
        loginPwTextField.layer.borderWidth = 0
    }
    
    // set textField left padding
    func makeTextFieldLeftPadding() {
        loginEmailTextField.addLoginTextFieldLeftPadding()
        loginPwTextField.addLoginTextFieldLeftPadding()
    }
    
    func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: - 버튼 내 텍스트 자간 설정
    func setButtonTextKerns(_ kernValue: CGFloat) {
        findEmailBtn.letterSpacing = kernValue
        findPwBtn.letterSpacing = kernValue
        signUpBtn.letterSpacing = kernValue
    }
    
    //MARK: - TextField 입력 체크하는 함수
    private func textFieldEditingCheck() {
        
        /// 텍스트가 입력중일 때 동작
        loginEmailTextField.addTarget(self, action: #selector(emailTextIsEditing(_:)), for: .editingChanged)
        loginPwTextField.addTarget(self, action: #selector(pwTextIsEditing(_:)), for: .editingChanged)
        
        /// 텍스트 입력 끝났을 때 동작
        loginEmailTextField.addTarget(self, action: #selector(emailTextIsEndEditing(_:)), for: .editingDidEnd)
        loginPwTextField.addTarget(self, action: #selector(pwTextIsEndEditing(_:)), for: .editingDidEnd)
    }
    
    
    //MARK: - emailTextField가 입력중일 때
    @objc func emailTextIsEditing(_ TextLabel: UITextField) {
        
        /// emailTextfield에 텍스트가 입력되면
        if loginEmailTextField.text!.count > 0 {
            
            //취소버튼을 보이게 한다
            cancelEmailTextingBtn.isHidden = false
        }
    }
    
    //MARK: - pwTextField가 입력중일 때
    @objc func pwTextIsEditing(_ TextLabel: UITextField) {
        
        /// pwTextfield에 텍스트가 입력되면
        if loginPwTextField.text!.count > 0 {
            
            //취소버튼을 보이게 한다
            cancelPwTextingBtn.isHidden = false
        }
    }
    
    //MARK: - emailTextField 입력 끝났을 때
    @objc func emailTextIsEndEditing(_ TextLabel: UITextField) {
        
        /// emailTextfield에 텍스트가 없으면
        if loginEmailTextField.text!.count == 0 {
            
            //취소버튼을 숨긴다
            cancelEmailTextingBtn.isHidden = true
        }
    }
    
    //MARK: - pwTextField 입력 끝났을 때
    @objc func pwTextIsEndEditing(_ TextLabel: UITextField) {
        
        /// pwTextfield에 텍스트가 없으면
        if loginPwTextField.text!.count == 0 {
            
            //취소버튼을 숨긴다
            cancelPwTextingBtn.isHidden = true
        }
    }
    
    
    //MARK: - emailTextField의 취소버튼을 눌렀을 때
    @IBAction func touchUpToEmailTextFieldClear(_ sender: UIButton) {
        // emailTextField의 텍스트 전부를 지우고, 취소버튼을 사라지게 한다
        loginEmailTextField.text?.removeAll()
        cancelEmailTextingBtn.isHidden = true
    }
    
    
    //MARK: - pwTextField의 취소버튼을 눌렀을 때
    @IBAction func touchUpToPwTextFieldClear(_ sender: UIButton) {
        // pwTextField의 텍스트 전부를 지우고, 취소버튼을 사라지게 한다
        loginPwTextField.text?.removeAll()
        cancelPwTextingBtn.isHidden = true
    }
    
    
    // 뷰의 다른 곳 탭하면 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true)
    }
    
    
    //MARK: - 연락처 동기화
    private func fetchContacts() {
        /// 1. The CNContactStore object contains the user’s contacts store database
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
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
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
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
            
        case .notDetermined:
            print("notDetermined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        }
        
    }
    
    
    func loginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    
    func goToCherishMainView(){
        let tabBarStoyboard: UIStoryboard = UIStoryboard(name: "TabBar", bundle: nil)
        if let tabBarVC = tabBarStoyboard.instantiateViewController(identifier: "CherishTabBarController") as? CherishTabBarController {
            tabBarVC.modalPresentationStyle = .fullScreen
            self.present(tabBarVC, animated: true, completion: nil)
        }
    }
    
    func goToNoPlantView() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "AddUser", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "NoPlantVC") as? NoPlantVC {
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    //MARK: - 로그인 버튼 눌렀을 때
    @IBAction func touchUpToLogin(_ sender: UIButton) {
        
        guard let emailText = loginEmailTextField.text,
              let passwordText = loginPwTextField.text else { return }
        LoginService.shared.doLogin(email: emailText, password: passwordText){ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                if let loginData = data as? LoginData {
                    UserDefaults.standard.set(loginData.userID, forKey: "userID")
                    print(UserDefaults.standard.integer(forKey: "userID"))
                    UserDefaults.standard.set(loginData.userNickname, forKey: "UserNickname")
                    
                    // 로그인 성공 시
                    // 유저 idx 기반으로 메인뷰에 등록된 소중한 사람이 있는지 조회
                    MainService.shared.inquireMainView(idx: loginData.userID){ [self]
                        (networkResult) -> (Void) in
                        switch networkResult {
                        case .success(let data):
                            if let mainData = data as? MainData {
                                
                                
                                // 등록된 소중한 사람의 수가 존재한다면
                                if mainData.totalCherish > 0 {
                                    
                                    // 메인뷰로 이동
                                    goToCherishMainView()
                                    makeCherishContacts()
                                }
                                
                                // 소중한 사람이 한명도 등록되지 않았다면
                                else {
                                    makeCherishContacts()
                                    //처음 서현이 뷰로 이동
                                    goToNoPlantView()
                                }
                            }
                        case .requestErr(let msg):
                            if let message = msg as? String {
                                self.loginAlert(title: "조회 실패", message: message)
                            }
                        case .pathErr:
                            print("pathErr")
                        case .serverErr:
                            print("serverErr")
                        case .networkFail:
                            print("networkFail")
                        }
                    }
                }
            case .requestErr(let msg):
                if let message = msg as? String {
                    if message == "비밀번호가 일치하지 않습니다"{
                        self.loginAlert(title: "비밀번호가 일치하지 않아요", message: "다시 확인해주세요")
                    }else{
                        self.loginAlert(title: "등록되어있지 않은 이메일이에요", message: "다시 확인해주세요")
                    }
                }
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    @IBAction func signUpAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "SignUp", bundle: nil)
        if let vc = storyBoard.instantiateViewController(identifier: "SignUpAccountVC") as? SignUpAccountVC {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - UITextFieldDelegate
extension LoginVC: UITextFieldDelegate {
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.loginEmailTextField.resignFirstResponder()
        self.loginPwTextField.resignFirstResponder()
    }
    
    // 키보드 return 눌렀을 때 Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginEmailTextField {
            loginPwTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue { UIView.animate(withDuration: 0.3, animations: {
                                                                                                                                            self.view.transform = CGAffineTransform(translationX: 0, y: -50) }) }
        
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification){ self.view.transform = .identity
    }
}
