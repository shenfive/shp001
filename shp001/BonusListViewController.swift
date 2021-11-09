//
//  BonusListViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/8.
//

import UIKit
import Firebase

class BonusListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    

    var selectedMonth = ""
    var ref:DatabaseReference!
    var orders:[Order] = []
    var userS:[[String:Any]] = []
    @IBOutlet weak var theTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "獎勵金列表"
        print(selectedMonth)
        ref = Database.database().reference()
        getUsers()
        reflashData()
        theTableView.delegate = self
        theTableView.dataSource = self
    }
    
    func calculateBonus(){
        if orders.count == 0 { return }
        for i in 0...orders.count - 1{
            let salesid = orders[i].sales.subString(start: orders[i].sales.count-10, end: orders[i].sales.count)
            if let invertorL1 = getIntor(userId: salesid){
                orders[i].intorL1 = invertorL1
                if let invertorL2 = getIntor(userId: invertorL1){
                    orders[i].intorL2 = invertorL2
                }
            }
            if orders[i].intorL2 == "" {
                if orders[i].isFirstOrder == true{
                    orders[i].intorL1Commission = Double(orders[i].totalPrice) * 0.1
                }else{
                    orders[i].intorL1Commission = Double(orders[i].totalPrice) * 0.05
                }
            }else{
                if orders[i].isFirstOrder == true{
                    orders[i].intorL1Commission = Double(orders[i].totalPrice) * 0.03
                    orders[i].intorL2Commission = Double(orders[i].totalPrice) * 0.07
                }else{
                    orders[i].intorL1Commission = Double(orders[i].totalPrice) * 0.03
                    orders[i].intorL2Commission = Double(orders[i].totalPrice) * 0.02
                }
            }
            theTableView.reloadData()
        }
    }
    
    func getIntor(userId:String) -> String?{
        for user in userS{
            if (user["phone"] as! String) == userId{
                return user["intor"] as? String
            }
        }
        return nil
    }
    
    
    
    func reflashData(){
        let year = selectedMonth.subString(start: 0, end: 4)
        let month = selectedMonth.subString(start: 4, end: 6)
//        dateInfoLabel.text = "目前顯示 \(year) 年 \(month) 月份訂單"
        ref.child("order/\(selectedMonth)").observeSingleEvent(of: .value) { snapshot in
            self.orders.removeAll()
//            var thisMonthTotal = 0
            if snapshot.hasChildren() == true {
                for item in snapshot.children{
                    
                    if let snapshotitem = item as? DataSnapshot{

                        let time = Date(timeIntervalSince1970:(snapshotitem.childSnapshot(forPath: "time").value as! Double) / 1000 )
                        
                        var theOrder = Order()
                        theOrder.key = snapshotitem.key
                        theOrder.time = time
                        theOrder.poNumber = snapshotitem.childSnapshot(forPath: "poNumber").value as! String
                        theOrder.sales = snapshotitem.childSnapshot(forPath: "sales").value as! String
                        theOrder.productName = snapshotitem.childSnapshot(forPath: "pname").value as! String
                        theOrder.productNumber = snapshotitem.childSnapshot(forPath: "pnum").value as! String
                        theOrder.qry = snapshotitem.childSnapshot(forPath: "qry").value as! Int
                        theOrder.uniprice = snapshotitem.childSnapshot(forPath: "upi").value as! Int
                        theOrder.disconuntRate = snapshotitem.childSnapshot(forPath: "drate").value as! Double
                        theOrder.payMent = snapshotitem.childSnapshot(forPath: "pay").value as! String
                        theOrder.isFirstOrder = snapshotitem.childSnapshot(forPath: "isFirstPO").value as! Bool
                        
                        self.orders.append(theOrder)
//                        thisMonthTotal += theOrder.total
                    }
                }
            }
            self.calculateBonus()
//            let formatter = NumberFormatter()
//            formatter.maximumFractionDigits = 0
//            formatter.numberStyle = .currency
//            let priceString = formatter.string(from: NSNumber(value: thisMonthTotal)) ?? ""
//            self.monthInfoLabel.text = "本月總金額: \(priceString)"
//            self.theTableView.reloadData()
        }
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let order = orders[indexPath.row]
        cell.textLabel?.text = "\(order.poNumber):  \(order.totalPrice):  \(order.intorL1Commission):  \(order.intorL2Commission)"
        return cell
    }


}
