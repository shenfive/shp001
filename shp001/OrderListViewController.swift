//
//  OrderListViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/4.
//

import UIKit
import Firebase

class OrderListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var theTableView: UITableView!
    @IBOutlet weak var lastMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    @IBOutlet weak var dateInfoLabel: UILabel!
    
    @IBOutlet weak var monthInfoLabel: UILabel!
    
    var ref:DatabaseReference!
    var selectedMonth = ""
    var orders:[Order] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "訂單例表"

        lastMonthButton.layer.cornerRadius = 22
        nextMonthButton.layer.cornerRadius = 22
        
        ref = Database.database().reference()
        
        theTableView.delegate = self
        theTableView.dataSource = self
        
        reflashData()
        
        
    }
    
    func reflashData(){
        let year = selectedMonth.subString(start: 0, end: 4)
        let month = selectedMonth.subString(start: 4, end: 6)
        dateInfoLabel.text = "目前顯示 \(year) 年 \(month) 月份訂單"
        ref.child("order/\(selectedMonth)").observeSingleEvent(of: .value) { snapshot in
            self.orders.removeAll()
            var thisMonthTotal = 0
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
                        thisMonthTotal += theOrder.totalPrice
                        
                    }
                }
            }
            let formatter = NumberFormatter()
            formatter.maximumFractionDigits = 0
            formatter.numberStyle = .currency
            let priceString = formatter.string(from: NSNumber(value: thisMonthTotal)) ?? ""
            self.monthInfoLabel.text = "本月總金額: \(priceString)"
            self.theTableView.reloadData()
        }
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTableViewCell") as! OrderTableViewCell
        print(orders[indexPath.row])
        let theOrder = orders[indexPath.row]
        cell.ponumber.text = "訂單編號: \(theOrder.poNumber)"
        cell.salesName.text = "業務員: \(theOrder.sales)"
        cell.productName.text = "產品名稱: \(theOrder.productName)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = dateFormatter.string(from: theOrder.time)
        cell.orderDate.text =  "日期: \(dateString)"
        cell.detailAction = {
            let nextVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "pODetailViewController") as! PODetailViewController
            nextVC.modalPresentationStyle = .overCurrentContext
            nextVC.theOrder = theOrder
            nextVC.editAction = {
                let editVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "editOrderViewController") as! EditOrderViewController
                editVC.theOrder = theOrder
                editVC.modalPresentationStyle = .overCurrentContext
                editVC.reflasuhAction = {
                    self.reflashData()
                }
                self.present(editVC, animated: true, completion: nil)
            }
            self.present(nextVC, animated: true, completion: nil)
        }
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        let priceString = formatter.string(from: NSNumber(value: theOrder.totalPrice)) ?? ""
        
        
        cell.total.text = "總額:\(priceString)"
        return cell
    }
    
    
    
    
}
                                     
