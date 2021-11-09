//
//  AccountManagerViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/7.
//

import UIKit
import Firebase

class AccountManagerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var keyWord: UITextField!
    @IBOutlet weak var keyWordContianer: UIView!
    @IBOutlet weak var showStopedAccount: UISwitch!
    
    
    var ref:DatabaseReference!
    var userS:[[String:Any]] = []
    var userC:[[String:Any]] = []
 
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "帳號管理"
        
        keyWordContianer.layer.cornerRadius = 22
        ref = Database.database().reference()

        

        
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.tableFooterView = UIView()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
  
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUsers()
    }
    


    
    func updateUsers(){
        Tools.showIndicator(inController: self)
        userS.removeAll()
        
        ref.child("users").observeSingleEvent(of: .value) { datasnap in
            for item in datasnap.children{
                let userSnapshot = item as! DataSnapshot
                let birthday = userSnapshot.childSnapshot(forPath: "birth").value as! String
                let deActive = userSnapshot.childSnapshot(forPath: "deat").value as! Bool
                let introducer = userSnapshot.childSnapshot(forPath: "intor").value as! String
                let level = userSnapshot.childSnapshot(forPath: "level").value as! Int
                let lineAccount = userSnapshot.childSnapshot(forPath: "line").value as! String
                let name = userSnapshot.childSnapshot(forPath: "name").value as! String
                let email = userSnapshot.childSnapshot(forPath: "email").value as! String
                let phone = userSnapshot.key
                let currentUser = ["birth":birthday,
                                   "deat":deActive,
                                   "email":email,
                                   "intor":introducer,
                                   "level":level,
                                   "line":lineAccount,
                                   "phone":phone,
                                   "name":name] as [String : Any]
                self.userS.append(currentUser)
            }
            self.setSelectedMembers()
        }
    }
    
    func setSelectedMembers(){
        userC.removeAll()
        let keyword = keyWord.text ?? ""

        for item in userS{
            if keyword.count == 0 ||
                (item["phone"] as! String).contains(keyword) ||
                (item["name"] as! String).contains(keyword) ||
                (item["birth"] as! String).contains(keyword){
                let deat = item["deat"] as! Bool
                if showStopedAccount.isOn == true {
                    userC.append(item)
                }else{
                    if deat == false{
                        userC.append(item)
                    }
                }
            }
        }
        Tools.removeIndicator(inController: self)
        self.theTableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "accountManageTableViewCell") as! AccountManageTableViewCell
        
        let deat = userC[indexPath.row]["deat"] as! Bool
        let statusString = "     狀態: " + (deat ?  "停用":"正常")
        let birthdayStriung = "     生日: " + (userC[indexPath.row]["birth"] as? String ?? "")

        cell.nameLabel.text = userC[indexPath.row]["name"] as? String ?? ""
        cell.detailLabel.text = (userC[indexPath.row]["phone"] as? String ?? "") + statusString + birthdayStriung
        cell.detailAndSetting = {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userDetailViewController") as! UserDetailViewController
            nextVC.modalPresentationStyle = .overCurrentContext
            nextVC.user = self.userC[indexPath.row]
            nextVC.dismissAction = {
                self.updateUsers()
            }
            self.present(nextVC, animated: true, completion: nil)
        }
        return cell
    }
    
    @IBAction func keywordChanged(_ sender: Any) {
        setSelectedMembers()
    }
    
    @IBAction func showStopedAccountChanged(_ sender: Any) {
        setSelectedMembers()
    }
    
}
