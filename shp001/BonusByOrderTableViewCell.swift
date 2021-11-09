//
//  BonusByOrderTableViewCell.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/9.
//

import UIKit

class BonusByOrderTableViewCell: UITableViewCell {

    @IBOutlet weak var poNumber: UILabel!
    
    @IBOutlet weak var commission1: UILabel!
    @IBOutlet weak var commission2: UILabel!
    @IBOutlet weak var orderDate: UILabel!
    @IBOutlet weak var sales: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var detailButton: UIButton!
    
    var detailAction:(()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailButton.layer.cornerRadius = 20
    }

    @IBAction func detailAction(_ sender: Any) {
        detailAction?()
    }
}
