//
//  UserDetailViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/7.
//

import UIKit
import Firebase

class UserDetailViewController: UIViewController {

    @IBOutlet weak var mainContianer: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var birthday: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var level: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var line: UILabel!
    @IBOutlet weak var intor: UILabel!
    @IBOutlet weak var phone: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var stopUser: UIButton!
    @IBOutlet weak var editUser: UIButton!
    
    
    var ref:DatabaseReference!
    var user:[String:Any] = [:]
    var dismissAction:(()->())? = nil
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        
        mainContianer.layer.cornerRadius = 20
        closeButton.layer.cornerRadius = 22
        stopUser.layer.cornerRadius = 22
        editUser.layer.cornerRadius = 22
    
        name.text = "姓名: " + (user["name"] as? String ?? "")
        birthday.text = "出生日期: " + (user["birth"] as? String ?? "")
        email.text = "電子郵件: " + (user["email"] as? String ?? "")
        phone.text = "手機號碼: " + (user["phone"] as? String ?? "")
        line.text = "line 帳號: " + (user["line"] as? String ?? "")
        
        let deat = user["deat"] as! Bool
        if deat == true {
            stopUser.setTitle("啟用", for: .normal)
        }
        status.text = "帳號狀態:" + (deat ?  "停用":"正常")
 
        let memberLevelArray = ["請上滑選擇","管理者","員工","一般會員","經銷商會員"]
        level.text = "會員等級: " + memberLevelArray[user["level"] as! Int]
        
 
        let intorKey = user["intor"] as! String
        
        if intorKey.count == 10 {
            ref.child("userK/\(intorKey)").observeSingleEvent(of: .value) { datasnap in
                let intorName = datasnap.value as! String
                self.intor.text = "介紹人: " + intorName + " " + intorKey
            }
        }else{
            self.intor.text = "介紹人: 無"
        }

    }
    
    
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    
    @IBAction func stopUser(_ sender: Any) {
        let name = (user["name"] as? String ?? "")
        let phone = (user["phone"] as? String ?? "")
        let deat = user["deat"] as! Bool
        if deat == false {
            let alert = UIAlertController(title: "停用\(name)?", message: "你確定要停用 \(name) 嗎，停用之後下次就無法登入", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { action  in
                if phone != "0979088745"{
                    self.ref.child("users/\(phone)/deat").setValue(true)
                    self.dismissAction?()
                    self.showAlert("已成功停用:\(name) \(phone)"){ action in
                        self.dismiss(animated: true, completion: nil)
                    }
                }else{
                    self.showAlert("無法刪除 Admin", action: nil)
                }
            }))
            self.present(alert, animated: true) {
            }
        }else{
            let alert = UIAlertController(title: "停用\(name)?", message: "你確定要啟用 \(name) 嗎?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "確定", style: .default, handler: { action  in
                
                self.ref.child("users/\(phone)/deat").setValue(false)
                self.dismissAction?()
                self.showAlert("已成功啟用:\(name) \(phone)"){ action in
                    self.dismiss(animated: true, completion: nil)
                }

                
            }))
            self.present(alert, animated: true) {
            }
        }

    }
    
    @IBAction func editUser(_ sender: Any) {
    }
    
}
