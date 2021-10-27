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
                    print("sign in")
                    print("=========A")
                }else{
                    print("=========B")
                    print(auth.currentUser?.email)
                    let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainInitTabBarVC") as! UITabBarController
                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true, completion: nil)
                }
            }else{
                let currentVC = Tools.getTopViewController()
                if currentVC != self{
                    currentVC?.navigationController?.viewControllers[0].dismiss(animated: true, completion: {
                        Tools.showToastMessage(message: "已登出", duration: 5)
                    })
                }
            }
        }
    }
    
    
    @IBAction func tryToLogin(_ sender: Any) {
        let account = accountTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        if account.count < 10 {
            showAlert("帳號應為 10 碼手機號碼")
            return
        }
        
        if password.count < 6 || password.count > 8 {
            showAlert("密碼應為 6~8 碼")
            return
        }
    
        print(ref.child("userK/\(account)"))
        
        ref.child("userK/\(account)").observeSingleEvent(of: .value, with: { snapshot in
            // Get user value
            print(snapshot.value)
            let realAccount = snapshot.value as? String
            if let realAccount = realAccount{
                self.auth.signIn(withEmail: realAccount, password: password) { result, error in
                    if let error = error{
                        self.showAlert(error.localizedDescription)
                        
                    }
                    
                    print("xxxA")
                    print(result?.user)
                    print("xxxB")
                    print(error)
                    print("xxxC")
                }
            }else{
                self.showAlert("帳號不存在，請再確認一次")
            }
            
            
            // ...
        }) { error in
            print(error.localizedDescription)
            print("dddd")
        }
        

        
    }
    
    
}

