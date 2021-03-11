//
//  NicknameChangeVC.swift
//  Cherish-iOS
//
//  Created by 황지은 on 2021/02/24.
//

import UIKit

class NicknameChangeVC: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet var userNicknameTextField: UITextField!
    @IBOutlet var userEmailTextField: UITextField!
    @IBOutlet var nicknameChangeCompleteBtn: UIButton!
    @IBOutlet var cancelNicknameTextingBtn: UIButton!
    @IBOutlet var userImageView: UIImageView!
    var profileImg: UIImage?
    var profileImgName: String = ""
    var isImage: Bool = false
    private let MAX_LENGTH = 6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButtonTextKerns(-0.7)
        makeDelegate()
        setFirstTextFieldText()
        cancelBtnNotVisible()
        setTextFieldBackgroud()
        makeTextFieldLeftPadding()
        keyboardObserver()
        textFieldEditingCheck()
        nicknameChangeCompleteBtn.isEnabled = false
        setUserImage()
        setImageViewRounded()
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange(_:)), name: NSNotification.Name(UITextField.textDidChangeNotification.rawValue) , object: userNicknameTextField)
    }
    
    func setUserImage() {
        if let image: UIImage
            = ImageFileManager.shared.getSavedImage(named: UserDefaults.standard.string(forKey: "uniqueImageName") ?? "") {
            if image == nil {
                userImageView.image = UIImage(named: "userImg")
            }
            userImageView.image = image
        }
    }
    
    //MARK: - 프로필 이미지 뷰 round 처리
    func setImageViewRounded() {
        userImageView.clipsToBounds = true
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }

    
    //MARK: - 버튼 내 텍스트 자간 설정
    func setButtonTextKerns(_ kernValue: CGFloat) {
        nicknameChangeCompleteBtn.letterSpacing = kernValue
        nicknameChangeCompleteBtn.letterSpacing = kernValue
        nicknameChangeCompleteBtn.letterSpacing = kernValue
    }
    
    func makeDelegate() {
        userNicknameTextField.delegate = self
        userEmailTextField.delegate = self
    }
    
    func setFirstTextFieldText() {
        //마이페이지에서 넘겨와서 받기!
        userNicknameTextField.text = UserDefaults.standard.string(forKey: "userNickname")
        userEmailTextField.text = UserDefaults.standard.string(forKey: "userEmail")
    }
    
    // cancel 버튼 처음 visible 상태를 false로
    func cancelBtnNotVisible() {
        cancelNicknameTextingBtn.isHidden = true
        userEmailTextField.isUserInteractionEnabled = false
    }
    
    // set textField background Image
    func setTextFieldBackgroud() {
        userNicknameTextField.background = UIImage(named: "editBox")
        userEmailTextField.background = UIImage(named: "editBox")
        userNicknameTextField.layer.borderWidth = 0
        userEmailTextField.layer.borderWidth = 0
    }
    
    // set textField left padding
    func makeTextFieldLeftPadding() {
        userNicknameTextField.addChangeNicknameTextFieldLeftPadding()
        userEmailTextField.addChangeNicknameTextFieldLeftPadding()
    }
    
    func keyboardObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
    //MARK: - TextField 입력 체크하는 함수
    private func textFieldEditingCheck() {
        
        /// 텍스트가 입력중일 때 동작
        userNicknameTextField.addTarget(self, action: #selector(nicknameTextIsEditing(_:)), for: .editingChanged)
        
        /// 텍스트 입력 끝났을 때 동작
        userNicknameTextField.addTarget(self, action: #selector(nicknameTextIsEndEditing(_:)), for: .editingDidEnd)
    }
    
    
    //MARK: - nicknameTextField가 입력중일 때
    @objc func nicknameTextIsEditing(_ TextLabel: UITextField) {
        
        /// emailTextfield에 텍스트가 입력되면
        if userNicknameTextField.text!.count > 0 {
            
            //취소버튼을 보이게 한다
            cancelNicknameTextingBtn.isHidden = false
            
            //변경완료 버튼을 활성화시킨다
            nicknameChangeCompleteBtn.isEnabled = true
            nicknameChangeCompleteBtn.setBackgroundImage(UIImage(named: "btnNextSelected"), for: .normal)
        }
    }
    
    //MARK: - nicknameTextField 입력 끝났을 때
    @objc func nicknameTextIsEndEditing(_ TextLabel: UITextField) {
        
        /// emailTextfield에 텍스트가 없으면
        if userNicknameTextField.text!.count == 0 {
            
            //취소버튼을 숨긴다
            cancelNicknameTextingBtn.isHidden = true
            
            //변경완료 버튼을 비활성화시킨다
            nicknameChangeCompleteBtn.isEnabled = false
            nicknameChangeCompleteBtn.setBackgroundImage(UIImage(named: "btnNextUnselected"), for: .normal)
        }
    }
    
    
    
    //MARK: - nicknameTextField의 취소버튼을 눌렀을 때
    @IBAction func touchUpToNicknameTextFieldClear(_ sender: UIButton) {
        // emailTextField의 텍스트 전부를 지우고, 취소버튼을 사라지게 한다
        userNicknameTextField.text?.removeAll()
        cancelNicknameTextingBtn.isHidden = true
    }
    
    
    // 뷰의 다른 곳 탭하면 키보드 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { self.view.endEditing(true)
    }
    
    func successAlert() {
        let nicknameChangeSuccessAlert = UIAlertController(title: "닉네임 변경 완료!", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
            self.navigationController?.popViewController(animated: true)
        }
        nicknameChangeSuccessAlert.addAction(confirmAction)
        self.present(nicknameChangeSuccessAlert, animated: true, completion: nil)
    }
    
    @IBAction func touchUpToChangePhotoBtn(_ sender: Any) {
        let myPicker = UIImagePickerController()
        myPicker.delegate = self
        myPicker.sourceType = .photoLibrary
        self.present(myPicker, animated: true, completion: nil)
    }
    
    @IBAction func touchUpToChangeNickname(_ sender: UIButton) {
        ChangeNicknameService.shared.updateNicknameInfo(userId:UserDefaults.standard.integer(forKey: "userID"), nickname: userNicknameTextField.text ?? "") { [self]
            (networkResult) -> (Void) in
            switch networkResult {
            case .success:
                //닉네임 변경 완료 alert
                self.successAlert()
                
                //닉네임 변경 후 update된 닉네임을 Userdefaults에 저장
                UserDefaults.standard.set(userNicknameTextField.text, forKey: "userNickname")
                
            case .requestErr(let msg):
                if let message = msg as? String {
                    print(message)
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
    
    @IBAction func touchUpToPopViewController(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK: - UITextFieldDelegate
extension NicknameChangeVC: UITextFieldDelegate {
    
    @objc func handleTapTextField(_ sender: UITapGestureRecognizer) {
        self.userNicknameTextField.resignFirstResponder()
        self.userEmailTextField.resignFirstResponder()
    }
    
    // 키보드 return 눌렀을 때 Action
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userNicknameTextField {
            userEmailTextField.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue { UIView.animate(withDuration: 0.3, animations: { self.view.transform = CGAffineTransform(translationX: 0, y: -50) }) }
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification){
        self.view.transform = .identity
    }
    
    //MARK: - 한글 6자에 맞춰 초과되는 텍스트를 제거하는 함수
    @objc private func textDidChange(_ notification: Notification) {
        
        if let textField = notification.object as? UITextField {
            if let text = textField.text {

                // 초과되는 텍스트 제거
                if text.count >= MAX_LENGTH {
                    let index = text.index(text.startIndex, offsetBy: MAX_LENGTH)
                    let newString = text.substring(to: index)
                    textField.text = newString
                }
            }
        }
    }
}
extension NicknameChangeVC: UIImagePickerControllerDelegate {
    func imagePickerController (_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            self.userImageView.image = image
            isImage = true
            
            if isImage == true {
                nicknameChangeCompleteBtn.isEnabled = true
                nicknameChangeCompleteBtn.setBackgroundImage(UIImage(named: "btnNextSelected"), for: .normal)
            }
            
            let uniqueFileName: String
              = "(ProcessInfo.processInfo.globallyUniqueString).jpeg"
            
            ImageFileManager.shared
              .saveImage(image: image,
                         name: uniqueFileName) { [weak self] onSuccess in
              print("saveImage onSuccess: \(onSuccess)")
                UserDefaults.standard.set(uniqueFileName, forKey: "uniqueImageName")
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel (_ picker: UIImagePickerController) { self.dismiss(animated: true, completion: nil)
    }
}
