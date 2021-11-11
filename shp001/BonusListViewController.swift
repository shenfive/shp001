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
    var listMode = "byOrder"
    var byMemberArray:[[String:Int]] = []
    
    @IBOutlet weak var theTableView: UITableView!
    
    @IBOutlet weak var byOrderButton: UIButton!
    @IBOutlet weak var byMemberButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var dateInfoLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "獎勵金列表"
        ref = Database.database().reference()
        reflashData()
        theTableView.delegate = self
        theTableView.dataSource = self
        byMemberButton.layer.cornerRadius = 20
        byOrderButton.layer.cornerRadius = 20
        lastMonthButton.layer.cornerRadius = 20
        nextMonthButton.layer.cornerRadius = 20
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
            
            calculateBonusByMember()
        }
    }
    
    func calculateBonusByMember(){
        byMemberArray.removeAll()
        for order in orders {
            if order.intorL1 != ""{
                if byMemberArray.filter { item in
                    return item.keys.first == order.intorL1
                }.first?.values.first == nil{
                    byMemberArray.append([order.intorL1:0])
                }
            }
            
            if order.intorL2 != ""{
                if byMemberArray.filter { item in
                    return item.keys.first == order.intorL2
                }.first?.values.first == nil{
                    byMemberArray.append([order.intorL2:0])
                }
            }
            
            for i in 0...byMemberArray.count-1{
                if byMemberArray[i].keys.first == order.intorL1{
                    var commission = byMemberArray[i][order.intorL1] ?? 0
                    commission += Int(order.intorL1Commission)
                    byMemberArray[i][order.intorL1] = commission
                }
                
                if byMemberArray[i].keys.first == order.intorL2{
                    var commission = byMemberArray[i][order.intorL2] ?? 0
                    commission += Int(order.intorL2Commission)
                    byMemberArray[i][order.intorL2] = commission
                }
            }
        }
        theTableView.reloadData()
    }
    
    
    func getIntor(userId:String) -> String?{
        for user in userS{
            if (user["phone"] as! String) == userId{
                return user["intor"] as? String
            }
        }
        return nil
    }
    
    func getMemberName(userId:String) -> String {
        for user in userS{
            if (user["phone"] as! String) == userId{
                return (user["name"] as? String) ?? ""
            }
        }
        return ""
    }
    
    
    
    func reflashData(){
        let year = selectedMonth.subString(start: 0, end: 4)
        let month = selectedMonth.subString(start: 4, end: 6)
        dateInfoLabel.text = "目前顯示 \(year) 年 \(month) 月份訂單"
        ref.child("order/\(selectedMonth)").observeSingleEvent(of: .value) { snapshot in
            self.orders.removeAll()
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
                    }
                }
                self.calculateBonus()
            }else{
                self.byMemberArray.removeAll()
                self.theTableView.reloadData()
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch listMode{
        case "byOrder":
            return orders.count
        case "byMember":
            return byMemberArray.count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch listMode{
        case "byOrder":
            let cell = tableView.dequeueReusableCell(withIdentifier: "bonusByOrderTableViewCell") as! BonusByOrderTableViewCell
            let order = orders[indexPath.row]
            cell.poNumber.text = "單號:\(order.poNumber)"
            cell.sales.text = "業務:\(order.sales)"
            cell.total.text = "金額:$\(order.totalPrice)"
            if order.intorL1 != ""{
                let intor1Name = getMemberName(userId: order.intorL1)
                cell.commission1.text = "介紹人1:\(intor1Name) \(order.intorL1)      獎金:$\(Int(order.intorL1Commission))"
            }else{
                cell.commission1.text = ""
            }
            
            if order.intorL2 != ""{
                let intor2Name = getMemberName(userId: order.intorL2) ?? ""
                cell.commission2.text = "介紹人2:\(intor2Name) \(order.intorL2)      獎金:$\(Int(order.intorL2Commission))"
            }else{
                cell.commission2.text = ""
            }
            cell.detailAction = {
                let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pODetailViewController") as! PODetailViewController
                nextVC.modalPresentationStyle = .overCurrentContext
                nextVC.theOrder = order
                nextVC.alloweEdit = false
                self.present(nextVC, animated: true, completion: nil)
            }
            return cell
        case "byMember":
            let cell = tableView.dequeueReusableCell(withIdentifier: "bonusByMemberTableViewCell") as! BonusByMemberTableViewCell
            cell.memberID.text =  "會員編號: " + (byMemberArray[indexPath.row].keys.first ?? "")
            cell.memberName.text = "會員姓名: " + getMemberName(userId: (byMemberArray[indexPath.row].keys.first ?? ""))
            let commission = byMemberArray[indexPath.row].values.first ?? 0
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            formatter.numberStyle = .currency
            let commissionString = formatter.string(from: NSNumber(value: commission)) ?? ""
            
            cell.commissionThisMonth.text = "本月份獎金： \(commissionString)"
            return cell
        default:
            return UITableViewCell()
        }
        
    }
    
    @IBAction func byMemberAction(_ sender: Any) {
        listMode = "byMember"
        theTableView.reloadData()
    }
    
    @IBAction func byOrderAction(_ sender: Any) {
        listMode = "byOrder"
        theTableView.reloadData()
    }
    
    
    @IBAction func lastMonth(_ sender: Any) {
        if  var year = Int(selectedMonth.subString(start: 0, end: 4)),
            var month = Int(selectedMonth.subString(start: 4, end: 6)){
            month -= 1
            if month == 0 {
                year -= 1
                month = 12
            }
            let mountString = String(format:"%02d",month)
            selectedMonth = "\(year)\(mountString)"
        }
        reflashData()
        
    }
    
    
    @IBAction func nextMonth(_ sender: Any) {
        if  var year = Int(selectedMonth.subString(start: 0, end: 4)),
            var month = Int(selectedMonth.subString(start: 4, end: 6)){
            month += 1
            if month == 13 {
                year += 1
                month = 1
            }
            let mountString = String(format:"%02d",month)
            selectedMonth = "\(year)\(mountString)"
        }
        reflashData()
    }
}
