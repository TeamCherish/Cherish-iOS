//
//  ReviewVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class ReviewVC: UIViewController {
    var letterCountingforExpand: Int? = 0 /// 키워드 길이에 따른 CollectionView 확장을 위한..
    var keyword = [String]() /// 키워드 배열
    
    
    //MARK: -@IBOutlet
    @IBOutlet weak var reviewNameLabel: CustomLabel! ///또령님! 남쿵둥이님과의
    @IBOutlet weak var reviewPlzLabel: CustomLabel! ///남쿵둥이님과의 물주기를 기록해주세요
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
            self.keywordCollectionView.register(KeywordCanDeleteCVC.nib(), forCellWithReuseIdentifier: KeywordCanDeleteCVC.identifier)
            keywordCollectionView.delegate = self
            keywordCollectionView.dataSource = self
            keywordCollectionView.collectionViewLayout = LeftAlignedFlowLayout()
        }
    }
    @IBOutlet weak var keywordCVHeight: NSLayoutConstraint!
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
        //keyboardUP() /// 키보드 올릴 때 사용
        
    }
    
    //MARK: -사용자 정의 함수
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
    
    @objc func doneBtnFromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        
        // 뭐라도 입력해야 키워드 등록
        if keywordTextField.text != ""{
            /// 키워드 배열에 저장
            keyword.append(keywordTextField.text!)
            /// 텍스트 필드 초기화 및 텍스트 필드 글자수 카운팅 초기화
            keywordTextField.text = ""
            keywordCountingLabel.text = "0/"
            /// 키워드 길이에 따른 CollectionView 확장을 위해 글자 수 계산
            letterCountingforExpand? += keyword.last?.count ?? 0
            /// 컬렉션 뷰 데이터 업데이트
            keywordCollectionView.reloadData()
            
            /// 키워드 길이에 따른 CollectionView 확장을 위한 if문
            if letterCountingforExpand ?? 0 > 20 {
                keywordCVHeight.constant = 88
            }
            /// 키워드 3개가 다 입력되면 키보드 내림
            if keyword.count >= 3 {
                self.view.endEditing(true)
            }
        }
    }
    
/// 키보드 올릴 때 사용
// 기기마다 텍스트필드가 가려지기도 하고 안가려지기도 하는데 이걸 어떻게..해야하지
//    func keyboardUP(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
//    }
//    @objc
//    func keyboardWillShow(_ sender: Notification) {
//
//        if keywordCVHeight.constant == 100 {
//            UIView.animate(withDuration: 2.0, animations: {
//                self.view.transform = CGAffineTransform(translationX: 0, y: -46)
//            })
//        }
//    }
//
//    @objc
//    func keyboardWillHide(_ sender: Notification) {
//
//        if keywordCVHeight.constant == 100 {
//            UIView.animate(withDuration: 2.0, animations: {
//                self.view.transform = CGAffineTransform(translationX: 0, y: 0)
//            })
//        }
//    }
    
    
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
        let newKeywordLength = currentCharacterCount + string.count - range.length
        /// 글자 수 실시간 카운팅
        keywordCountingLabel.text =  "\(String(newKeywordLength-1))"+"/"
        /// 최대 글자 수 10
        return newKeywordLength <= 10
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /// 키워드가 이미 3개인데 사용자가 입력하려한다면 막음
        if keyword.count >= 3 {
            nomoreKeyword(title: "", message: "키워드는 3개까지 쓸 수 있어요!")
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
        let newMemoLength = currentCharacterCount + text.count - range.length
        /// 글자 수 실시간 카운팅
        memoCountingLabel.text =  "\(String(newMemoLength-1))"+"/"
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
        if memoTextView.text == "메모" {
            memoTextView.text = ""
            memoTextView.textColor = .black
        }
        else if memoTextView.text == "" {
            memoTextView.text = "메모"
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
        /// 키워드 길이에 따른 CollectionView 축소를 위해 글자 수 계산
        letterCountingforExpand? -= keyword[indexPath.row].count

        keyword.remove(at: indexPath.row)
        keywordCollectionView.reloadData()
        
        /// 키워드는 최대 3개인데 이 곳을 거치면 키워드는 무조건 2개이고
        /// 2개일 경우 확장 될 경우의 수 없음
        keywordCVHeight.constant = 50
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCanDeleteCVC.identifier, for: indexPath) as? KeywordCanDeleteCVC else{
            return UICollectionViewCell()
        }
        cell.keywordLabel.text = keyword[indexPath.row]
        let label = UILabel(frame: CGRect.zero)
        label.text = keyword[indexPath.row]
        label.sizeToFit()
        
        return cell
    }
    //MARK: - Cell 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let label = UILabel(frame: CGRect.zero)
        label.text = keyword[indexPath.row]
        label.sizeToFit()
        let cellSize = label.frame.width+26
        
        return CGSize(width: cellSize, height: 29)
        
    }
    
    //MARK: - Cell간의 좌우간격 지정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        return 5
    }
    
    //MARK: - 마진
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsets(top: 9, left: 0, bottom: 10, right: 0)
    }
}
