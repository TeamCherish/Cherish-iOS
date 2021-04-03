//
//  ReviewEditVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/08.
//

import UIKit

class ReviewEditVC: UIViewController{
    var space: String? /// 메모 내용
    var edit_keyword = [String]() /// 키워드 배열
    var edit_date : String? /// 메모 작성 날짜
    var dateForServer : String?
    var reciever: Int = 0
    let maxLength_keyword  = 5 /// 키워드 최대 입력 5글자
    let maxLength_memo  = 100 /// 메모 최대 입력 100글자
    
    @IBOutlet weak var editMemoDateLabel: CustomLabel!
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
    @IBOutlet weak var keywordLimitLabel: CustomLabel!{
        didSet{
            keywordLimitLabel.textColor = .placeholderGrey
        }
    }
    @IBOutlet weak var keywordCollectionView: UICollectionView!{
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
    @IBOutlet weak var memoLimitLabel: CustomLabel!{
        didSet{
            memoLimitLabel.textColor = .placeholderGrey
        }
    }
    @IBOutlet weak var completeBtn: UIButton!{
        didSet{
            completeBtn.makeRounded(cornerRadius: 25.0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadMemo()
        textViewPlaceholder()
        checkingLetterCount() //글자 수 검사 노티
        decideMainMyPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self) //  self에 등록된 옵저버 전체 제거
    }
    
    //MARK: -사용자 정의 함수
    // 글자 수 검사 노티들 가진 함수
    func checkingLetterCount(){
        NotificationCenter.default.addObserver(self, selector: #selector(textfieldDidChange(_:)), name: UITextField.textDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(textviewDidChange(_:)), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    // 1. 키워드 입력 TextField 글자 수 감시(& 복붙 검사)
    @objc private func textfieldDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            if let text = textField.text {
                
                if text.count > maxLength_keyword {
                    // 5글자 넘어가면 자동으로 키보드 내려감
                    textField.resignFirstResponder()
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
    
    // 2. 메모 입력 TextView 글자 수 감시(& 복붙 검사)
    @objc private func textviewDidChange(_ notification: Notification) {
        if let textView = notification.object as? UITextView {
            if let text = textView.text {
                
                if text.count > maxLength_memo {
                    // 100글자 넘어가면 자동으로 키보드 내려감
                    textView.resignFirstResponder()
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
            edit_keyword.append(keywordTextField.text!)
            /// 텍스트 필드 초기화 및 텍스트 필드 글자수 카운팅 초기화
            keywordTextField.text = ""
            keywordCountingLabel.text = "0/"
            print(edit_keyword)
            /// 컬렉션 뷰 데이터 업데이트
            keywordCollectionView.reloadData()
            /// 키워드 3개가 다 입력되면 키보드 내림
            if edit_keyword.count >= 3 {
                self.view.endEditing(true)
            }
        }
    }
    
    func loadMemo(){
        memoTextView.text = space
        memoCountingLabel.text = "\(String(memoTextView.text.count))"+"/"
        editMemoDateLabel.text = edit_date
    }
    ///Alert
    func nomoreKeyword(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Alert의 '확인'을 누르면 dismiss
        let okAction = UIAlertAction(title: "확인",style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func loginAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인",style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    func deleteAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirm = UIAlertAction(title: "삭제",style: .destructive) { [self] (action) in
            // DELETE 서버 통신
            CalendarService.shared.reviewDelete(CherishId: reciever, water_date: dateForServer!) { (networkResult) -> (Void) in

                switch networkResult {
                case .success(_):
                    /// 삭제됐을 경우 캘린더가 아니라 식물카드뷰로 나가기
                    let controllers = self.navigationController?.viewControllers
                    for vc in controllers! {
                        if vc is PlantDetailVC {
                            _ = self.navigationController?.popToViewController(vc as! PlantDetailVC, animated: true)
                        }
                    }
                    print("success")
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
        let cancel = UIAlertAction(title: "취소",style: .default)
        alert.addAction(cancel)
        alert.addAction(confirm)
        present(alert, animated: true)
    }
    
    func decideMainMyPage(){
        // 마이페이지에서 온건지 메인에서 온건지
        if UserDefaults.standard.bool(forKey: "plantIsSelected") == true{
            reciever = UserDefaults.standard.integer(forKey: "selectedCherish")
        }else{
            reciever = UserDefaults.standard.integer(forKey: "selectedFriendIdData")
        }
    }
    
    @IBAction func moveToBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func deleteMemo(_ sender: Any) {
        deleteAlert(title: "정말로 메모를 삭제하시겠어요?", message: "삭제된 메모는 되돌릴 수 없어요")
    }
    @IBAction func completeEdit(_ sender: Any) {
        
        if edit_keyword.count == 0 {
            edit_keyword = ["","",""]
        }
        if edit_keyword.count == 1 {
            edit_keyword.append("")
            edit_keyword.append("")
        }
        if edit_keyword.count == 2 {
            edit_keyword.append("")
        }
        if memoTextView.text == "메모를 입력해주세요!"{
            memoTextView.text = ""
        }
        CalendarService.shared.reviewEdit(CherishId: reciever, water_date: dateForServer!, review: memoTextView.text, keyword1: edit_keyword[0], keyword2: edit_keyword[1], keyword3: edit_keyword[2]) { (networkResult) -> (Void) in

            switch networkResult {
            case .success(_):
                self.navigationController?.popViewController(animated: true)
                print("success")
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
extension ReviewEditVC: UITextFieldDelegate,UITextViewDelegate{
    /// 키워드 부분 글자수 Counting
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return false }
        
        let newKeywordLength = text.count + string.utf16.count - range.length
        /// 글자 수 실시간 카운팅
        keywordCountingLabel.text =  "\(String(newKeywordLength))"+"/"
        
        /// 5글자 채우면 6으로 표시되는거 해결
        if newKeywordLength >= maxLength_keyword {
            keywordCountingLabel.text =  "5/"
        }
        
        /// 최대 글자 수 5
        if text.count >= maxLength_keyword && range.length == 0 && range.location < maxLength_keyword {
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// 키워드가 이미 3개인데 사용자가 입력하려한다면 막음
        if edit_keyword.count >= 3 {
            nomoreKeyword(title: "", message: "키워드는 3개까지 쓸 수 있어요!")
            self.view.endEditing(true) /// 알림창 후 키보드 내림
        }
    }
    
    /// 메모 부분 글자수 Counting
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = memoTextView.text else { return false }

        let newMemoLength = str.count + text.utf16.count - range.length
        /// 글자 수 실시간 카운팅
        memoCountingLabel.text =  "\(String(newMemoLength))"+"/"

        /// 100글자 채우면 101로 표시되는거 해결
        if newMemoLength >= maxLength_memo {
            memoCountingLabel.text =  "100/"
        }

        /// 최대 100글자
        if text.count >= maxLength_memo && range.length == 0 && range.location < maxLength_memo {
            return false
        }

        return true
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
extension ReviewEditVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /// 키워드 터치시 삭제
        edit_keyword.remove(at: indexPath.row)
        keywordCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return edit_keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordReviewEditCVC.identifier, for: indexPath) as? KeywordReviewEditCVC else{
            return UICollectionViewCell()
        }
        cell.eidtKeywordLabel.text = edit_keyword[indexPath.row]
        return cell
    }
    
    //MARK: - Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        label.text = edit_keyword[indexPath.row]
        label.sizeToFit()
        let cellSize = label.frame.width+25
        
        return CGSize(width: cellSize, height: 29)
    }
}
