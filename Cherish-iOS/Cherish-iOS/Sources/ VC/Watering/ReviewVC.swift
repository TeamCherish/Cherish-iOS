//
//  ReviewVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class ReviewVC: UIViewController {
    var keyword: [String] = []/// 키워드 배열
    var reciever: Int = 0
    var phoneNumber: String?
    var contentStatus: Bool = false
    let maxLength_keyword  = 5 /// 키워드 최대 입력 5글자
    let maxLength_memo  = 100 /// 메모 최대 입력 100글자
    let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //MARK: -@IBOutlet
    @IBOutlet weak var reviewNameLabel: CustomLabel! ///또령님! 남쿵둥이님과(와)의
    @IBOutlet weak var reviewPlzLabel: CustomLabel! ///남쿵둥이님과(와)의 물주기를 기록해주세요
    @IBOutlet weak var keywordTextField: UITextField!{
        didSet{
            keywordTextField.delegate = self
        }
    }
    @IBOutlet weak var keywordCountingLabel: UILabel!
    @IBOutlet weak var keywordLimitLabel: UILabel!
    @IBOutlet weak var keywordCollectionView: UICollectionView! {
        didSet{
            keywordCollectionView.delegate = self
            keywordCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var memoTextView: UITextView!{
        didSet{
            memoTextView.delegate = self
        }
    }
    @IBOutlet weak var memoCountingLabel: UILabel!
    @IBOutlet weak var memoLimitLabel: UILabel!
    @IBOutlet weak var submit: UIButton!
    @IBOutlet weak var skip: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPlaceholder() /// textView Placeholder 셋팅
        if UIDevice.current.isiPhoneSE2 {
            print("iPhoneSE2")
            keyboardUP() /// 키보드 올릴 때 사용
        }
        setStyle()
        setNamingLabel()
        setBtnNotText()
        addLetterCountNoti() // 글자 수 검사 노티
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self) //  self에 등록된 옵저버 전체 제거
    }
    
    // 등록완료
    @IBAction func submitReview(_ sender: Any) {
        if contentStatus {
            // 마이페이지에서 온건지 메인에서 온건지
            if UserDefaults.standard.bool(forKey: "plantIsSelected") == true{
                reciever = UserDefaults.standard.integer(forKey: "selectedCherish")
            }else{
                reciever = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
            }
            
            // 키워드 부족한건 ""로 채움
            for _ in 0..<3-keyword.count {
                keyword.append("")
            }
            
            UserDefaults.standard.set(false, forKey: "reviewNotYet")
            
            // .POST (메모 입력 안했으면 Placeholder 상태니까 삼항연산 이용해서 처리)
            WateringReviewService.shared.wateringReview(review: memoTextView.text == "메모를 입력해주세요!" ? nil:memoTextView.text, keyword1: keyword[0], keyword2: keyword[1], keyword3: keyword[2], CherishId: reciever) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    print(data)
                    if UserDefaults.standard.bool(forKey: "plantIsSelected") == false {
                        NotificationCenter.default.post(name: .wateringReport, object:reciever)
                    }
                    self.dismiss(animated: true, completion: {
                        NotificationCenter.default.post(name: .popToMainView, object: nil)
                        UserDefaults.standard.set(false, forKey: "plantIsSelected")
                    })
                case .requestErr(_):
                    print("requestErr")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }else{
            self.basicAlert(title: nil, message: "키워드 또는 메모를 입력 후 \n 등록을 완료해주세요!")
        }
    }
    
    @IBAction func submitLater(_ sender: Any) {
        
        // 마이페이지에서 온건지 메인에서 온건지
        if UserDefaults.standard.bool(forKey: "plantIsSelected") == true{
            reciever = UserDefaults.standard.integer(forKey: "selectedCherish")
        }else{
            reciever = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
        }
        
        UserDefaults.standard.set(false, forKey: "reviewNotYet")
        
        // .POST nil값은 Resources/APIService/Watering/WateringReviewService에서 nil병합 연산자 이용
        WateringReviewService.shared.wateringReview(review: nil, keyword1: nil, keyword2: nil, keyword3: nil, CherishId: reciever) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
                if UserDefaults.standard.bool(forKey: "plantIsSelected") == false {
                    NotificationCenter.default.post(name: .wateringReport, object:reciever)
                }
                self.dismiss(animated: true, completion: {
                    NotificationCenter.default.post(name: .popToMainView, object: nil)
                    UserDefaults.standard.set(false, forKey: "plantIsSelected")
                })
            case .requestErr(_):
                print("requestErr")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
}

extension ReviewVC {
    func setStyle() {
        keywordTextField.addLeftPadding()
        keywordTextField.addLeftPadding()
        
        textFieldDoneBtnMake(text_field: keywordTextField) //Done
        
        keywordTextField.backgroundColor = .inputGrey
        keywordTextField.attributedPlaceholder = NSAttributedString(string: "키워드로 표현해주세요!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderGrey])
        keywordTextField.makeRounded(cornerRadius: 8)
        keywordCountingLabel.textColor = .black
        keywordLimitLabel.textColor = .placeholderGrey
        
        memoTextView.makeRounded(cornerRadius: 10.0)
        memoTextView.backgroundColor = .inputGrey
        /// TextView 커서 Padding
        memoTextView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 55, right: 15);
        
        memoCountingLabel.textColor = .black
        memoLimitLabel.textColor = .placeholderGrey
        
        submit.makeRounded(cornerRadius: 25.0)
        
        skip.makeRounded(cornerRadius: 25.0)
        skip.backgroundColor = .inputGrey
        skip.tintColor = .placeholderGrey
    }
    
    // 글자 수 검사 노티들 가진 함수
    func addLetterCountNoti(){
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textviewDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // 1. 키워드 입력 TextField 글자 수 Counting(& 복붙 검사)
    @objc private func textfieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                keywordCountingLabel.text =  "\(text.count)"+"/"
                
                if text.count > maxLength_keyword {
                    // 5글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
                    keywordCountingLabel.text =  "5/"
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength_keyword {
                    let index = text.index(text.startIndex, offsetBy: maxLength_keyword)
                    let newString = text[text.startIndex..<index]
                    textField.text = String(newString)
                }
            }
        }
    }
    
    // 2. 메모 입력 TextView 글자 수 Counting(& 복붙 검사)
    @objc private func textviewDidChange(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            if let text = textView.text {
                
                memoCountingLabel.text = "\(text.count)"+"/"
                
                if text.count > maxLength_memo {
                    // 100글자 넘어가면 자동으로 키보드 내려감
                    textView.resignFirstResponder()
                    memoCountingLabel.text = "100/"
                }
                
                // 초과되는 텍스트 제거
                if text.count >= maxLength_memo {
                    let index = text.index(text.startIndex, offsetBy: maxLength_memo)
                    let newString = text[text.startIndex..<index]
                    textView.text = String(newString)
                }
            }
        }
    }
    
    
    
    //MARK: -사용자 정의 함수
    /// 키보드 Done 버튼 생성
    func textFieldDoneBtnMake(text_field : UITextField)
    {
        let ViewForDoneButtonOnKeyboard:UIToolbar = UIToolbar(frame: CGRect(x:0,y:0,width: UIScreen.main.bounds.width,height: 50))
        ViewForDoneButtonOnKeyboard.barStyle = .default
        ViewForDoneButtonOnKeyboard.sizeToFit()
        /// Done 버튼 우측으로 이동
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnFromKeyboardClicked))
        let items = [flexSpace, done]
        ViewForDoneButtonOnKeyboard.items = items
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    /// Done 버튼 클릭 시 이벤트
    @objc func doneBtnFromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        
        // 뭐라도 입력해야 키워드 등록
        if keywordTextField.text != ""{
            /// 키워드 배열에 저장
            keyword.append(keywordTextField.text!)
            /// 등록했다는 건 키워드가 1개 이상이라는 것 - 채워진 버튼(삭제시 로직은 delegate에)
            setBtnYesText()
            /// 텍스트 필드 초기화 및 텍스트 필드 글자수 카운팅 초기화
            keywordTextField.text = ""
            keywordCountingLabel.text = "0/"
            
            /// 컬렉션 뷰 데이터 업데이트
            keywordCollectionView.insertItems(at: [IndexPath(item: keyword.count-1, section: 0)])
            /// 키워드 3개가 다 입력되면 키보드 내림
            if keyword.count >= 3 {
                self.view.endEditing(true)
            }
        }
    }
    
    
    //MARK:- 키보드 올릴 때 사용
    func keyboardUP(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        /// 텍스트 뷰 입력할 때에만 키보드 올리면 됨
        if memoTextView.isFirstResponder{
            UIView.animate(withDuration: 2.0, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -26)
            })
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        /// 텍스트 뷰 입력할 때에만 키보드 올리면 됨
        if memoTextView.isFirstResponder{
            UIView.animate(withDuration: 2.0, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    func setNamingLabel(){
        reviewNameLabel.text = "\(UserDefaults.standard.string(forKey: "UserNickname")!)"+"님! "+"\(UserDefaults.standard.string(forKey: "wateringNickName")!)"+"와(과)의"
        reviewPlzLabel.text = "\(UserDefaults.standard.string(forKey: "wateringNickName")!)"+"와(과)의 물주기를 기록해주세요"
    }
    
    
    /// 아무것도 안썼을 때 보더만 있는 등록완료 버튼
    func setBtnNotText(){
        submit.backgroundColor = .white
        submit.layer.borderColor = UIColor.seaweed.cgColor
        submit.layer.borderWidth  = 1.0
        submit.titleLabel?.textColor = .seaweed
        contentStatus = false
    }
    
    /// 무언가를 썼을 때 채워진 등록완료 버튼
    func setBtnYesText(){
        submit.backgroundColor = .seaweed
        submit.titleLabel?.textColor = .white
        contentStatus = true
    }
}

//MARK: -Protocols
/// 1
extension ReviewVC: UITextFieldDelegate,UITextViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// 키워드가 이미 3개인데 사용자가 입력하려한다면 막음
        if keyword.count >= 3 {
            self.basicAlert(title: nil, message: "키워드는 3개까지 입력할 수 있어요!")
            self.view.endEditing(true) /// 알림창 후 키보드 내림
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if memoTextView.text == "" {
            textViewPlaceholder()
         }else if textView.text.count > 0 {
            setBtnYesText()
        }
    }
    
    func textViewPlaceholder() {
        if memoTextView.text == "메모를 입력해주세요!" {
            memoTextView.text = ""
            memoTextView.textColor = .black
        } else if memoTextView.text == "" {
            memoTextView.text = "메모를 입력해주세요!"
            memoTextView.textColor = .placeholderGrey
            if keyword.count == 0{
                setBtnNotText()
            }
        }
    }
    
    ///Return 눌렀을 때 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    ///화면 터치시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

///2
extension ReviewVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 키워드 터치시 삭제
        keyword.remove(at: indexPath.row)
        keywordCollectionView.deleteItems(at: [IndexPath(item: indexPath.row, section: 0)])
        
        /// 키워드를 삭제했을 때 메모도 없고 키워드가 0개이면
        if keyword.count == 0 && memoTextView.text == "메모를 입력해주세요!" {
            setBtnNotText()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCanDeleteCVC.identifier, for: indexPath) as? KeywordCanDeleteCVC else{
            return UICollectionViewCell()
        }
        cell.keywordLabel.text = keyword[indexPath.row]
        return cell
    }
    
    /// Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        label.text = keyword[indexPath.row]
        label.sizeToFit()
        let cellSize = label.frame.width+25
        
        return CGSize(width: cellSize, height: 29)
        
    }
}
