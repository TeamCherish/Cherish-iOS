//
//  ReviewVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class ReviewVC: UIViewController {
    var keyword : [String] = [] /// 키워드 배열
    let keywordMaxLength = 5 /// 키워드 글자 제한
    let memoMaxLength = 100 /// 메모 글자 제한
    
    //MARK: -@IBOutlet
    @IBOutlet weak var reviewNameLabel: CustomLabel! /// 또령님! 남쿵둥이님과/와의
    @IBOutlet weak var reviewPlzLabel: CustomLabel! /// 남쿵둥이님과/와의 물주기를 기록해주세요
    @IBOutlet weak var keywordTextField: UITextField!{
        didSet{
            keywordTextField.delegate = self
            keywordTextField.addLeftPadding()
            keywordTextField.addLeftPadding()
            textFieldDoneBtnMake(text_field: keywordTextField) //Done
            keywordTextField.backgroundColor = .inputGrey
            keywordTextField.attributedPlaceholder = NSAttributedString(string: "키워드로 표현해주세요!", attributes: [NSAttributedString.Key.foregroundColor : UIColor.placeholderGrey])
            keywordTextField.makeRounded(cornerRadius: 8)
        }
    }
    @IBOutlet weak var keywordCountingLabel: UILabel!{
        didSet{
            keywordCountingLabel.textColor = .black
        }
    }
    @IBOutlet weak var keywordLimitLabel: UILabel!{
        didSet{
            keywordLimitLabel.textColor = .placeholderGrey
        }
    }
    @IBOutlet weak var keywordCollectionView: UICollectionView!
    {
        didSet{
            keywordCollectionView.delegate = self
            keywordCollectionView.dataSource = self
        }
    }
    @IBOutlet weak var memoTextView: UITextView!{
        didSet{
            memoTextView.delegate = self
            memoTextView.makeRounded(cornerRadius: 10.0)
            memoTextView.backgroundColor = .inputGrey
            /// TextView 커서 Padding
            memoTextView.textContainerInset = UIEdgeInsets(top: 14, left: 16, bottom: 55, right: 15);
        }
    }
    @IBOutlet weak var memoCountingLabel: UILabel!{
        didSet{
            memoCountingLabel.textColor = .black
        }
    }
    @IBOutlet weak var memoLimitLabel: UILabel!{
        didSet{
            memoLimitLabel.textColor = .placeholderGrey
        }
    }
    
    @IBOutlet weak var submit: UIButton!{
        didSet{
            submit.makeRounded(cornerRadius: 25.0)
        }
    }
    @IBOutlet weak var skip: UIButton!{
        didSet{
            skip.makeRounded(cornerRadius: 25.0)
            skip.backgroundColor = .inputGrey
            skip.tintColor = .placeholderGrey
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPlaceholder() /// textView Placeholder 셋팅
        if UIDevice.current.isiPhoneSE2 {
            print("iPhoneSE2")
            keyboardUP() /// 키보드 올릴 때 사용
        }
        setNamingLabel()
        textCopyBug()
    }
    
    //MARK:- Alert
    func nomoreKeyword(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Alert의 '확인'을 누르면 dismiss
        let okAction = UIAlertAction(title: "확인",style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    /// 리뷰 안쓰고 등록완료 할 시 Alert
    func reviewAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
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
            /// 텍스트 필드 초기화 및 텍스트 필드 글자수 카운팅 초기화
            keywordTextField.text = ""
            keywordCountingLabel.text = "0/"
            print(keyword)
            
            /// 컬렉션 뷰 데이터 업데이트
            keywordCollectionView.reloadData()
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
    
    func textCopyBug(){
        NotificationCenter.default.addObserver(self,selector: #selector(textDidChange(_:)),name: UITextField.textDidChangeNotification,object: keywordTextField)
        NotificationCenter.default.addObserver(self,selector: #selector(textDidChange(_:)),name: UITextField.textDidChangeNotification,object: memoTextView)
    }
    
    @objc
    func keyboardWillShow(_ sender: Notification) {
        /// 텍스트 뷰 입력할 때에만 키보드 올리면 됨
        if memoTextView.isFirstResponder{
            UIView.animate(withDuration: 2.0, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -26)
            })
        }
    }
    
    @objc
    func keyboardWillHide(_ sender: Notification) {
        /// 텍스트 뷰 입력할 때에만 키보드 올리면 됨
        if memoTextView.isFirstResponder{
            UIView.animate(withDuration: 2.0, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
            })
        }
    }
    
    @objc private func textDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                // 초과되는 텍스트 제거
                if text.count >= keywordMaxLength {
                    print("키워드글자초과키워드글자초과키워드글자초과키워드글자초과")
                    let index = text.index(text.startIndex, offsetBy: keywordMaxLength)
                    let newString = text[text.startIndex..<index]
                    keywordTextField.text = String(newString)
                }
            }
        }
        
        if let textView = notification.object as? UITextView {
            if let text = textView.text {
                // 초과되는 텍스트 제거
                print("메모글자초과메모글자초과메모글자초과메모글자초과메모글자초과")
                if text.count >= memoMaxLength {
                    let index = text.index(text.startIndex, offsetBy: memoMaxLength)
                    let newString = text[text.startIndex..<index]
                    memoTextView.text = String(newString)
                }
            }
        }
    }
    
    /// View 상단 네이밍 라벨 셋팅
    func setNamingLabel(){
        reviewNameLabel.text = "\(UserDefaults.standard.string(forKey: "UserNickname")!)"+"님! "+"\(UserDefaults.standard.string(forKey: "wateringNickName")!)"+"과/와의"
        reviewPlzLabel.text = "\(UserDefaults.standard.string(forKey: "wateringNickName")!)"+"과/와의 물주기를 기록해주세요"
    }
    
    // 리뷰 등록 완료(애정도 +2)
    @IBAction func submitReview(_ sender: Any) {
        
        if keyword.count == 0 && memoTextView.text == "메모를 입력해주세요!"{
            reviewAlert(title: "Cherish", message: "리뷰 등록을 완료해주세요!")
        }else{
            ///키워드 nil값 대체
            if keyword.count == 2 {
                keyword.append("")
            }else if keyword.count == 1 {
                keyword.append("")
                keyword.append("")
            }else if keyword.count == 0 {
                keyword.append("")
                keyword.append("")
                keyword.append("")
            }
            WateringReviewService.shared.wateringReview(review: memoTextView.text, keyword1: keyword[0], keyword2: keyword[1], keyword3: keyword[2], CherishId: UserDefaults.standard.integer(forKey: "selectedFriendIdData")) { [self] (networkResult) -> (Void) in
                switch networkResult {
                case .success(let data):
                    print(data)
                    self.dismiss(animated: true, completion: nil)
                    
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
    
    /// 다음에 할게요(애정도 + 1)
    @IBAction func submitLater(_ sender: Any) {
        keyword = ["","",""]
        WateringReviewService.shared.wateringReview(review: "", keyword1: keyword[0], keyword2: keyword[1], keyword3: keyword[2], CherishId: UserDefaults.standard.integer(forKey: "selectedFriendIdData")) { [self] (networkResult) -> (Void) in
            switch networkResult {
            case .success(let data):
                print(data)
                self.dismiss(animated: true, completion: nil)
                
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

//MARK: -Protocols
/// 1
extension ReviewVC: UITextFieldDelegate,UITextViewDelegate{
    /// 키워드 부분 글자수 Counting
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newKeywordLength = currentCharacterCount + string.utf16.count - range.length
        /// 글자 수 실시간 카운팅
        keywordCountingLabel.text =  "\(String(newKeywordLength))"+"/"
        
        /// 한글에서 5자 채우면 6자로 표시되는거 해결
        if newKeywordLength >= keywordMaxLength {
            keywordCountingLabel.text =  "5/"
        }
        
        /// 최대 글자 수 5
        return newKeywordLength <= keywordMaxLength
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// 키워드가 이미 3개인데 사용자가 입력하려한다면 막음
        if keyword.count >= 3 {
            nomoreKeyword(title: "", message: "키워드는 3개까지 입력할 수 있어요!")
            self.view.endEditing(true) /// 알림창 후 키보드 내림
        }
    }
    
    /// 메모 부분 글자수 Counting
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentCharacterCount = memoTextView.text?.count ?? 0
        if text == "\n" {
            textView.resignFirstResponder()
        }
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newMemoLength = currentCharacterCount + text.utf16.count - range.length
        /// 글자 수 실시간 카운팅
        memoCountingLabel.text =  "\(String(newMemoLength))"+"/"
        
        /// 한글에서 100자 채우면 101자로 표시되는거 해결
        if newMemoLength >= 100 {
            memoCountingLabel.text =  "100/"
        }
        /// 최대 글자 수 100자
        return newMemoLength <= 100
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewPlaceholder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if memoTextView.text == "" {
            textViewPlaceholder()
        }
    }
    
    func textViewPlaceholder() {
        if memoTextView.text == "메모를 입력해주세요!" {
            memoTextView.text = ""
            memoTextView.textColor = .black
        }
        else if memoTextView.text == "" {
            memoTextView.text = "메모를 입력해주세요!"
            memoTextView.textColor = .placeholderGrey
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
        keywordCollectionView.reloadData()
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
    
    //MARK: - Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        label.text = keyword[indexPath.row]
        label.sizeToFit()
        let cellSize = label.frame.width+25
        
        return CGSize(width: cellSize, height: 29)
        
    }
}
