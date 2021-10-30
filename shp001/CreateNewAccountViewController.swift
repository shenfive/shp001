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
        print(birthdatDatePicker.date.timeIntervalSince1970)
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
        let displayName = nameTextField.text ?? ""
        let phone = phoneTextField.text ?? ""
        let level = memberLevelPicker.selectedRow(inComponent: 0)
        let lineAccount = lineAccountTextField.text ?? ""
        let birthday = birthdatDatePicker.date
        
        print(birthday.timeIntervalSince1970)
        
        
    
        
        if displayName.count < 2{
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
        
        if birthday.timeIntervalSince1970 == 1609383601.233261 {
            showAlert("請確實選擇出生日期")
            return
        }
        
        Tools.showIndicator(inController: self)
        ref.child("userK/\(phone)").observeSingleEvent(of: .value) { snapshot1 in
            let name = snapshot1.value as? String // 不能有相同號碼
            if let name = name{
                Tools.removeIndicator(inController: self)
                self.showAlert("這個電話己由【\(name)】使用，請使用其他號碼")
                return
            }else{
                let encodeEmail = email.replacingOccurrences(of: ".", with: "@@")
                self.ref.child("userE/\(encodeEmail)").observeSingleEvent(of: .value) { snapshot2 in
                    let name2 = snapshot2.value as? String
                    if let name2 = name2 {
                        Tools.removeIndicator(inController: self)
                        self.showAlert("這個電子郵件己由【\(name2)】使用，請使用其他電子郵件")
                    }else{
                        //正式建立帳號
                        
                        let formater = DateFormatter()
                        formater.dateFormat = "yyyy-MM-dd"
                        let birthdayString = formater.string(from: birthday)
                        let formater2 = DateFormatter()
                        formater2.dateFormat = "yyMMdd"
                        let initPassword = formater2.string(from: birthday)
                        let alert = UIAlertController(title: "再次確認",
                                                      message: "請注意，【電子郵件】與【手機號碼】一旦建立，無法修改，也無法刪除，請再次確認資料無誤\n\n電話:\(phone)\n手機號碼\(phone)\n電子郵件:\(email)姓名:\(displayName)\n初始密碼:\(initPassword)",
                                                      preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
                        alert.addAction(UIAlertAction(title: "確認建立", style: .default, handler: { action in
                            Auth.auth().createUser(withEmail: email,
                                                   password: initPassword) { result, error in
                                
                                if let error = error{
                                    Tools.removeIndicator(inController: self)
                                    self.showAlert("建立帳號錯誤\nCode:\(error.localizedDescription)")
                                }else{
                                    let item = ["birth":birthdayString,
                                                "deat":false,
                                                "email":email,
                                                "intor":self.selectedIntroduer ?? "no",
                                                "level":level,
                                                "line":lineAccount,
                                                "name":displayName] as [String : Any]
                                    self.ref.child("users/\(phone)").setValue(item)
                                    self.ref.child("userE/\(encodeEmail)").setValue(phone)
                                    self.ref.child("userK/\(phone)").setValue(displayName)
                                    let lastAccount = UserDefaults.standard.value(forKey: "lastAccount") as! String
                                    let lastPasword = UserDefaults.standard.value(forKey: "lastPasword") as! String
                                    Auth.auth().signIn(withEmail: lastAccount,
                                                       password: lastPasword) { result, error in
                                        Tools.removeIndicator(inController: self)
                                        print("UserUID")
                                        print(Auth.auth().currentUser?.uid)
                                        if let error = error{
                                            self.showAlert("重登帳號錯誤\nCode:\(error.localizedDescription)")
                                        }else{
                                            self.showAlert("成功建立帳號！\n帳號:\(phone)\n初始密碼:\(initPassword)") { action in
                                                self.navigationController?.popViewController(animated: true)
                                            }
                                        }
                                    }
                                }
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        
        
    }
    
    
}
