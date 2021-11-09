//
//  BonusCalViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/8.
//

import UIKit
import Firebase

class BonusCalViewController: UIViewController {

    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var lastMonthButtn: UIButton!
    
    var selectedMonthString = ""
    var ref:DatabaseReference!
    var userS:[[String:Any]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "獎勵金計算"
        ref = Database.database().reference()
        getUsers()
        thisMonthButton.layer.cornerRadius = 20
        lastMonthButtn.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goBonusList":
            let nextVC = segue.destination as! BonusListViewController
            nextVC.userS = self.userS
            nextVC.selectedMonth = selectedMonthString
        default:
            break
        }
    }
    
    
    @IBAction func thisMonth(_ sender: Any) {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let mountString = String(format:"%02d",month)
        selectedMonthString = "\(year)\(mountString)"
        performSegue(withIdentifier: "goBonusList", sender: self)
    }
    
    @IBAction func lastMonth(_ sender: Any) {
        var year = Calendar.current.component(.year, from: Date())
        var month = Calendar.current.component(.month, from: Date()) - 1
        if month == 0 {
            month = 12
            year -= 1
        }
        let mountString = String(format:"%02d",month)
        selectedMonthString = "\(year)\(mountString)"
        performSegue(withIdentifier: "goBonusList", sender: self)
    }
    
    func getUsers(){
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
        }
    }
    
}
