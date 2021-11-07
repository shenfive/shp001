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
    
    var ref:DatabaseReference!
    var theOrder:Order = Order()
    @IBOutlet weak var poNumberLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        mainContainer.layer.cornerRadius = 20
        poNumberLabel.text = "訂單編號: \(theOrder.poNumber)"

    }
    
    @IBAction func cloaseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
