//
//  IntroducerPickerViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/29.
//

import UIKit
import Firebase

class IntroducerPickerViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var keywordContainer: UIView!
    
    var ref:DatabaseReference!
    var userS:[[String:String]] = []
    var userC:[[String:String]] = []
    var setIntroduerAction:((String,String)->())? = nil
    
    
    @IBOutlet weak var keywordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keywordContainer.clipsToBounds = true
        keywordContainer.layer.cornerRadius = 22
        theTableView.delegate = self
        theTableView.dataSource = self
        theTableView.tableFooterView = UIView()
        
        userS.removeAll()
        ref = Database.database().reference()
        ref.child("userK").observeSingleEvent(of: .value) { datasnap in
            for item in datasnap.children{
                let member = ["phone":(item as! DataSnapshot).key,
                              "name":(item as! DataSnapshot).value as! String]
                self.userS.append(member)
            }
            self.setSelectedMembers()
        }
        
    }
    
    //重設介紹人篩選
    func setSelectedMembers(){
        userC.removeAll()
        let keyword = keywordTextField.text ?? ""

        for item in userS{
            if keyword.count == 0 ||
                (item["phone"] ?? "").contains(keyword) ||
                (item["name"] ?? "").contains(keyword){
                userC.append(item)
            }
        }
        self.theTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userC.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "introTableViewCell") as! IntroTableViewCell
        let name = userC[indexPath.row]["name"] ?? ""
        cell.nameLabel.text = name
        let phone = userC[indexPath.row]["phone"] ?? ""
        cell.phneLabel.text = phone
        cell.selectionStyle = .none
        cell.selectedAction = {
            self.setIntroduerAction?(phone,name)
        }
        return cell
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true) {
        }
    }
    
    @IBAction func indexChanged(_ sender: Any) {

        setSelectedMembers()
    }
    
}
