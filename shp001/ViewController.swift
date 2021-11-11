//
//  ViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/26.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref:DatabaseReference!
    var auth:Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登入頁"
        UINavigationBar.appearance().backgroundColor = UIColor.white
        UINavigationBar.appearance().tintColor = UIColor.blue
        UINavigationBar.appearance().isTranslucent = false
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 22
        
        ref = Database.database().reference()
        auth = FirebaseAuth.Auth.auth()
        
        if auth.currentUser == nil {
            auth.signInAnonymously { result, error in
            }
        }
        
        auth.addStateDidChangeListener { auth, user in
            if let user = user{
                
                if auth.currentUser?.isAnonymous == true{
                    print("sign in with Anonymous")
                }else{
                    UserDefaults.standard.setValue(Date(), forKey: "lastLoginDate")
                    Tools.showIndicator(inController: self)
                    if let email = auth.currentUser?.email{
                        let encodeEmail = email.replacingOccurrences(of: ".", with: "@@")
                        self.ref.child("userE/\(encodeEmail)").observeSingleEvent(of: .value) { snapshot in
                            let account = snapshot.value as! String
                            self.ref.child("users/\(account)").observeSingleEvent(of: .value) { userSnapshot in
                                let birthday = userSnapshot.childSnapshot(forPath: "birth").value as! String
                                let deActive = userSnapshot.childSnapshot(forPath: "deat").value as! Bool
                                let introducer = userSnapshot.childSnapshot(forPath: "intor").value as! String
                                let level = userSnapshot.childSnapshot(forPath: "level").value as! Int
                                let lineAccount = userSnapshot.childSnapshot(forPath: "line").value as! String
                                let name = userSnapshot.childSnapshot(forPath: "name").value as! String
                                let phone = userSnapshot.key
                                let currentUser = ["birth":birthday,
                                                   "deat":deActive,
                                                   "email":email,
                                                   "intor":introducer,
                                                   "level":level,
                                                   "line":lineAccount,
                                                   "phone":phone,
                                                   "name":name] as [String : Any]
                                UserDefaults.standard.setValue(currentUser, forKey: "currentUser")
                                UserDefaults.standard.synchronize()
                                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainInitTabBarVC") as! UITabBarController
                                nextVC.modalPresentationStyle = .fullScreen
                                Tools.removeIndicator(inController: self)
                                self.present(nextVC, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }else{
                //登出時，回到登入頁
                let currentVC = Tools.getTopViewController()
                if currentVC != self{
                    currentVC?.navigationController?.viewControllers[0].dismiss(animated: true, completion: {
                        Tools.showToastMessage(message: "已登出", duration: 4)
                    })
                }
                //登出時自動匿名登入，以存取資料庫
                auth.signInAnonymously { result, error in
                }
            }
        }
    }
    
    
    @IBAction func tryToLogin(_ sender: Any) {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if validateCellPhone(account) !=  true {
            showAlert("帳號應為 10 碼手機號碼")
            return
        }
        
        if password.count < 6  {
            showAlert("密碼為 6 碼以上的英文/數字")
            return
        }

        Tools.showIndicator(inController: self)
        ref.child("users/\(account)/email").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            let realAccount = snapshot.value as? String
            if let realAccount = realAccount{
                self.ref.child("users/\(account)/deat").observeSingleEvent(of: .value) { snapshot in
                    let isDeAtived = snapshot.value as? Bool
                    if isDeAtived != true{
                        self.auth.signIn(withEmail: realAccount, password: password) { result, error in
                            Tools.removeIndicator(inController: self)
                            if let error = error{
                                self.showAlert("登入錯誤:\(error.localizedDescription)")
                            }
                            
                            //存下最後一個 password / account
                            if let user = result?.user{
                                UserDefaults.standard.setValue(password, forKey: "lastPasword")
                                UserDefaults.standard.setValue(realAccount, forKey: "lastAccount")
                                UserDefaults.standard.synchronize()
                                self.passwordTextField.text = nil
                                self.accountTextField.text = nil
                            }
                        }
                    }else{
                        Tools.removeIndicator(inController: self)
                        self.showAlert("你的帳號己被停用，請與管理者連絡")
                    }
                }
            
                
                
                
                
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

