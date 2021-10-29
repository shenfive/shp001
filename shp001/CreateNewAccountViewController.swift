//
//  CreateNewAccountViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/29.
//

import UIKit
import Firebase

class CreateNewAccountViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  
    
    @IBOutlet weak var memberLevelPicker: UIPickerView!
    @IBOutlet weak var pickItroButton: UIButton!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var removeItroButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var birthdatDatePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var lineAccountTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var memberLevelArray = ["請上滑選擇","管理者","員工","一般會員","經銷商會員"]
    var ref:DatabaseReference!
    var selectedIntroduer:String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "建立新帳號"
        memberLevelPicker.delegate = self
        memberLevelPicker.dataSource = self
        pickItroButton.layer.cornerRadius = 16.5
        removeItroButton.layer.cornerRadius = 16.5
        createAccountButton.layer.cornerRadius = 22
        ref = Database.database().reference()
    }
    

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return memberLevelArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return memberLevelArray[row]
    }
    
    @IBAction func pickItroAction(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "introducerPickerViewController") as! IntroducerPickerViewController
        nextVC.setIntroduerAction = {
            self.selectedIntroduer = $0
            self.introLabel.text = "\($1)    \($0)"
            nextVC.dismiss(animated: true) {
                
            }
        }
        present(nextVC, animated: true) {
            
        }
    }
    
    @IBAction func removeItronAction(_ sender: Any) {
        introLabel.text = "尚未選定"
        selectedIntroduer = nil
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        let email = (emailTextField.text ?? "").lowercased()
        let name = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let level = memberLevelPicker.selectedRow(inComponent: 0)
        let lineAccount = lineAccountTextField.text ?? ""
        let birthday = birthdatDatePicker.date
        
        print(birthday.timeIntervalSince1970)
        
        
        if name.count < 2{
            showAlert("請輸入姓名，至少兩個字元")
            return
        }
        
        if validateCellPhone(phone) !=  true {
            showAlert("手機號碼應為 10 碼，做為帳號使用")
            return
        }
        
        if validateEmail(email) != true{
            showAlert("電子郵件格式不符規定")
            return
        }
        
        if level == 0 {
            showAlert("請選擇會員等級")
            return
        }
        
        if birthday.timeIntervalSince1970 == 946695601.2332611 {
            showAlert("請確實選擇出生日期")
            return
        }
        
        
        
        
    }
    
    
}
