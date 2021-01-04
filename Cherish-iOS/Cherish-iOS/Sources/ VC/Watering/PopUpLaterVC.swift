//
//  PopUpLaterVC.swift
//  Cherish-iOS
//
//  Created by 이원석 on 2021/01/04.
//

import UIKit

class PopUpLaterVC: UIViewController {
    let date = [1,2,3,4,5,6,7] // 미루기 최대 7일
    var test = 21
    
    //MARK: -@IBOutlet
    @IBOutlet weak var laterView: UIView!{
        didSet{
            laterView.makeRounded(cornerRadius: 20.0)
        }
    }
    @IBOutlet weak var changeDateMonthLabel: UILabel!
    @IBOutlet weak var changeDateDayLabel: UILabel!
    
    @IBOutlet weak var laterPickerView: UIPickerView!{
        didSet{
            laterPickerView.delegate = self
            laterPickerView.dataSource = self
        }
    }
    @IBOutlet weak var laterCountingLabel: UILabel! ///(현재까지 미룬 횟수 n회)
    @IBOutlet weak var confirmBtn: UIButton!{
        didSet{
            confirmBtn.makeRounded(cornerRadius: 23.0)
            confirmBtn.backgroundColor = .btnGrey
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: -Protocols
extension PopUpLaterVC: UIPickerViewDelegate, UIPickerViewDataSource{
    /// 하나의 PickerView 안에 몇 개의 선택 가능한 리스트를 표시할 것인지
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    /// PickerView에 표시될 항목의 개수를 반환하는 메서드
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return date.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(date[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        /// 1월-31 2월-28 3월-31일 4월-30일 5월-31일
        /// 6월-30일 7월-31일 8월-31일 9월-30일 10월-31
        /// 11월-30일 12월-31일
        /// 구분해줘야함
        changeDateDayLabel.text = "\(test+date[row])"
    }
    
    /// pickerView 내부 라벨 색, 폰트
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
            if pickerLabel == nil {
                pickerLabel = UILabel()
                pickerLabel?.font = UIFont(name: "Roboto-Regular", size: 16)
                pickerLabel?.textAlignment = .center
                pickerLabel?.textColor = .black
            }
            pickerLabel?.text = String(date[row])
            return pickerLabel!
    }
    
}
