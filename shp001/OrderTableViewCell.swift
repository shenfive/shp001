//
//  OrderTableViewCell.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/4.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    @IBOutlet weak var ponumber: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var salesName: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
 
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        detailButton.layer.cornerRadius = 20
    }
    
    @IBAction func detailAction(_ sender: Any) {
    }
    
}
