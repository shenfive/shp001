//
//  ChangePasswordViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/28.
//

import UIKit
import Firebase

class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPassworTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var checkNewPasswordTextField: UITextField!
    
    @IBOutlet weak var subminButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        subminButton.layer.cornerRadius = 22
        
        title = "變更密碼"
        self.tabBarController?.tabBar.isHidden = true
        let x = UserDefaults.standard.value(forKey: "lastPasword") as! String
        print("x:\(x)")
    }
    
    
    @IBAction func changePasswordSubmit(_ sender: Any) {
        let currentPW = currentPassworTextField.text ?? ""
        let newPW = newPasswordTextField.text ?? ""
        let checkPW = checkNewPasswordTextField.text ?? ""
        let oldPWmd5 = UserDefaults.standard.value(forKey: "lastPasword") as! String
        
        if currentPW.count < 6 {
            showAlert("原密確應為 6 碼以上英數字")
            return
        }
        
        if newPW.count < 6 {
            showAlert("新密碼確應為 6 碼以上英數字")
            return
        }
        
        if newPW != checkPW {
            showAlert("新密碼與確認密碼不同\n請重新檢查")
            return
        }
        
        
        if currentPW.md5() != oldPWmd5{
            showAlert("舊密碼不正確，請再檢查一次")
            return
        }
        
        Tools.showIndicator(inController: self)
        Auth.auth().currentUser?.updatePassword(to: newPW) { error in
            Tools.removeIndicator(inController: self)
            if let error = error {
                self.showAlert("變更失敗\nCode:\(error.localizedDescription)")
            }else{
                self.showAlert("成功變更密碼，請以新密碼重新登入") { action in
                    do {
                        try Auth.auth().signOut()
                    } catch  {
                        self.showAlert("系統錯誤\n請與管理者連絡")
                    }
                }
            }
        }
        
        
        
    }
    
    
    
    
}
