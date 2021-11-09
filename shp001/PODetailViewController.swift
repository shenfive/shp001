//
//  PODetailViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/8.
//

import UIKit
import Firebase

class PODetailViewController: UIViewController {

    @IBOutlet weak var mainContainer: UIView!
    @IBOutlet weak var poNumberLabel: UILabel!
    @IBOutlet weak var poTime: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productNumber: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var uniPrice: UILabel!
    @IBOutlet weak var qty: UILabel!
    @IBOutlet weak var dispcountRate: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var isFirstOrder: UILabel!
    
    
    
    var ref:DatabaseReference!
    var theOrder:Order = Order()
    var editAction:(()->())? = nil

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        mainContainer.layer.cornerRadius = 20
        closeButton.layer.cornerRadius = 22
        editButton.layer.cornerRadius = 22
        poNumberLabel.text = "訂單編號: \(theOrder.poNumber)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd hh:mm"
        let dateString = dateFormatter.string(from: theOrder.time)
        poTime.text = "訂單日期: \(dateString)"
        productNumber.text = "產品編號: \(theOrder.productNumber)"
        productName.text = "產品名稱: \(theOrder.productName)"
        payment.text = "付款方式: \(theOrder.payMent)"
        uniPrice.text = "產品單價: \(theOrder.uniprice)"
        qty.text = "數量: \(theOrder.qry)"
        sales.text = "業務員: \(theOrder.sales)"
        
        if theOrder.isFirstOrder == true{
            isFirstOrder.text = "首次交易: 是"
        }else{
            isFirstOrder.text = "首次交易: 否"
        }
        
        if theOrder.disconuntRate == 1.0{
            dispcountRate.text = "折扣率: 依定價"
        }else{
            let str = String(format: "%2.1f", theOrder.disconuntRate * 100)
            dispcountRate.text = "折扣率: \(str)%"
        }
        
        let price = Double( theOrder.qry * theOrder.uniprice ) * theOrder.disconuntRate
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = .currency
        let priceString = formatter.string(from: NSNumber(value: price)) ?? ""
        total.text = " 訂單總額: \(priceString)"

    }
    
    @IBAction func cloaseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func editAction(_ sender: Any) {
        self.dismiss(animated: true) {
            self.editAction?()
        }
    }
}
