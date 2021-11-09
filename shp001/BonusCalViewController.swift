//
//  BonusCalViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/8.
//

import UIKit

class BonusCalViewController: UIViewController {

    @IBOutlet weak var thisMonthButton: UIButton!
    @IBOutlet weak var lastMonthButtn: UIButton!
    
    var selectedMonthString = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "獎勵金計算"
        thisMonthButton.layer.cornerRadius = 20
        lastMonthButtn.layer.cornerRadius = 20
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier{
        case "goBonusList":
            let nextVC = segue.destination as! BonusListViewController
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
    
}
