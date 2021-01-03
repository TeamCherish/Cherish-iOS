//
//  ReviewVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/03.
//

import UIKit

class ReviewVC: UIViewController {
    var keyword = [String]() /// 키워드 배열
    
    //MARK: -@IBOutlet
    @IBOutlet weak var reviewNameLabel: CustomLabel!{
        didSet{
            reviewNameLabel.textColor = .black
        }
    }
    @IBOutlet weak var reviewWhatupLabel: CustomLabel!{
        didSet{
            reviewWhatupLabel.textColor = .black
        }
    }
    @IBOutlet weak var reviewPlzLabel: UILabel!{
        didSet{
            reviewPlzLabel.textColor = .black
        }
    }
    
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
            self.keywordCollectionView.register(KeywordCVC.nib(), forCellWithReuseIdentifier: KeywordCVC.identifier)
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
            skip.backgroundColor = .btnGrey
            skip.tintColor = .btnGrey
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textViewPlaceholder()
    }
    
    //MARK: -사용자 정의 함수
    func textFieldDoneBtnMake(text_field : UITextField)
    {
        let ViewForDoneButtonOnKeyboard = UIToolbar()
        ViewForDoneButtonOnKeyboard.sizeToFit()
        let btnDoneOnKeyboard = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneBtnFromKeyboardClicked))
        ViewForDoneButtonOnKeyboard.items = [btnDoneOnKeyboard]
        text_field.inputAccessoryView = ViewForDoneButtonOnKeyboard
    }
    
    @objc func doneBtnFromKeyboardClicked (sender: Any) {
        print("Done Button Clicked.")
        
        if keyword.count >= 3{
            print("full")
            keywordTextField.text = ""
            self.view.endEditing(true)
        }else{
            keyword.append(keywordTextField.text!)
            keywordTextField.text = ""
            print(keyword)
            keywordCollectionView.reloadData()
            //Hide Keyboard by endEditing or Anything you want. self.view.endEditing(true)
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
        let newKeywordLength = currentCharacterCount + string.count - range.length
        keywordCountingLabel.text =  "\(String(newKeywordLength))"+"/"
        return newKeywordLength <= 10
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
        memoCountingLabel.text =  "\(String(newMemoLength))"+"/"
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
        keyword.remove(at: indexPath.row)
        keywordCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keyword.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: KeywordCVC.identifier, for: indexPath) as? KeywordCVC else{
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
        return CGSize(width: label.frame.width+20, height: 29)
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
