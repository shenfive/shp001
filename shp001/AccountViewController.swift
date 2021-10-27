//
//  AccountViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/27.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func signOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            
            showAlert("無法登出\nCode:\(error.localizedDescription)")
        }
        
        
    }
}
