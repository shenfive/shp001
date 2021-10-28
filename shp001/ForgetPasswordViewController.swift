//
//  ForgetPasswordViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/28.
//

import UIKit
import Firebase

class ForgetPasswordViewController: UIViewController {
    
    var ref:DatabaseReference!
    var auth:Auth!
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var submintButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "忘記密碼"
        
        submintButton.layer.cornerRadius = 22
        
        ref = Database.database().reference()
        auth = FirebaseAuth.Auth.auth()
    }

    @IBAction func forgetPasswordAction(_ sender: Any) {
        let account = accountTextField.text ?? ""
        if validateCellPhone(account) !=  true {
            showAlert("帳號應為 10 碼手機號碼")
            return
        }
        Tools.showIndicator(inController: self)
        ref.child("userK/\(account)").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let realAccount = snapshot.value as? String
            if let realAccount = realAccount{
                self.auth.sendPasswordReset(withEmail: realAccount) { error in
                    Tools.removeIndicator(inController: self)
                    if let error = error{
                        self.showAlert("變更密碼系統錯誤:\(error.localizedDescription)")
                    }else{
                        self.showAlert("已發出變更密碼確認電子郵件\n請檢查以下電子郵件件並變更密碼\n\(realAccount)") { alert in
                            self.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                }
//                self.auth.signIn(withEmail: realAccount, password: password) { result, error in
//                    Tools.removeIndicator(inController: self)
//                    if let error = error{
//                        self.showAlert("登入錯誤:\(error.localizedDescription)")
//                    }
//
//                    //存下最後一個 password
//                    if let user = result?.user{
//                        UserDefaults.standard.setValue(password.md5(), forKey: "lastPasword")
//                        UserDefaults.standard.synchronize()
//                        self.passwordTextField.text = nil
//                        self.accountTextField.text = nil
//                        print("pp:\(password.md5())")
//                    }
//                }
            }else{
                Tools.removeIndicator(inController: self)
                self.showAlert("帳號不存在，請再確認一次")
            }
        }) { error in
            Tools.removeIndicator(inController: self)
            self.showAlert("登入錯系統發生錯誤請\n稍候再試或與管理人員連絡\n代碼：\(error.localizedDescription)")
        }
    }
        
    
}
