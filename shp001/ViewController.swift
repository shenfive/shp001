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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "登入頁"
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 22
        
        
        
        let auth = FirebaseAuth.Auth.auth()
        if auth.currentUser == nil {
            auth.signInAnonymously { result, error in
                

            }
        }
        
        
        
        auth.addStateDidChangeListener { auth, user in
            if let user = user{
                print("sign in")
            }else{
                print("not sign in")
            }
        }
        
    }
}

