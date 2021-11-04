//
//  OrderFormViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/30.
//

import UIKit

class OrderFormViewController: UIViewController {

    
    
    @IBOutlet weak var newOrderButton: UIButton!
    @IBOutlet weak var currentMonthButton: UIButton!
    @IBOutlet weak var lastMonthButton: UIButton!
    
    var selectedMonthString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "訂單管理"

        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        newOrderButton.layer.cornerRadius = 20
//        newOrderButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        currentMonthButton.layer.cornerRadius = 20
//        currentMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        lastMonthButton.layer.cornerRadius = 20
//        lastMonthButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goOrders":
            let nextVC = segue.destination as! OrderListViewController
            nextVC.selectedMonth = self.selectedMonthString
            break
        default:
            break
        }
    }
    
    @IBAction func lastMonthAction(_ sender: Any) {
        var year = Calendar.current.component(.year, from: Date())
        var month = Calendar.current.component(.month, from: Date()) - 1
        if month == 0 {
            month = 12
            year -= 1
        }
        let mountString = String(format:"%02d",month)
        selectedMonthString = "\(year)\(mountString)"
        performSegue(withIdentifier: "goOrders", sender: self)
    }
    
    @IBAction func thisMonth(_ sender: Any) {
        let year = Calendar.current.component(.year, from: Date())
        let month = Calendar.current.component(.month, from: Date())
        let mountString = String(format:"%02d",month)
        selectedMonthString = "\(year)\(mountString)"
        performSegue(withIdentifier: "goOrders", sender: self)
    }
    
}
