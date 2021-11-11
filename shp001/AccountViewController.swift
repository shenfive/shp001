//
//  AccountViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/27.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {

    @IBOutlet weak var helloLabel: UILabel!
    @IBOutlet weak var userInfoContainer: UIView!
    
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var liginTimeLabel: UILabel!
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var accountListButton: UIButton!
    
    var ref:DatabaseReference!
    var auth:Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帳號管理"
        
        ref = Database.database().reference()
        auth = FirebaseAuth.Auth.auth()
        
        let userInfo = Tools.currentSevedUser()
        if let name = userInfo["name"] as? String{
            helloLabel.text = " 您好    \(name)  先生/女士"
            phoneLabel.text = "手機號碼 : \(userInfo["phone"] as! String)"
            emailLabel.text = "E-Mail : \(userInfo["email"] as! String)"
            let loginDate = UserDefaults.standard.value(forKey: "lastLoginDate") as! Date
            let formater = DateFormatter()
            formater.dateFormat = "MM/dd HH:mm:ss"
            let string = formater.string(from: loginDate)
            liginTimeLabel.text = "登入時間 : \(string)"
            switch userInfo["level"] as! Int{
            case 1:
                levelLabel.text = "帳號層級:管理者"
            case 2:
                levelLabel.text = "帳號層級:員工"
            case 3:
                levelLabel.text = "帳號層級:一般會員"
            case 4:
                levelLabel.text = "帳號層級:經銷商會員"
            default:
                levelLabel.text = "帳號層級:不明"
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
        userInfoContainer.clipsToBounds = false
        userInfoContainer.layer.shadowRadius = 20         //陰影
        userInfoContainer.layer.shadowOpacity = 0.6;
        userInfoContainer.layer.shadowColor = UIColor.gray.cgColor
        userInfoContainer.layer.shadowOffset = CGSize(width: 10, height: 10)

        logoutButton.layer.cornerRadius = 20
//        logoutButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        
        changePasswordButton.layer.cornerRadius = 20
//        changePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        createButton.layer.cornerRadius = 20
//        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        accountListButton.layer.cornerRadius = 20
//        accountListButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
 
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)


    }
    

    @IBAction func signOut(_ sender: Any) {
        
        do {
            try Auth.auth().signOut()
        } catch {
            
            showAlert("無法登出\nCode:\(error.localizedDescription)")
        }
        
        
    }
}
