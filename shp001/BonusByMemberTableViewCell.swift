//
//  BonusByMemberTableViewCell.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/9.
//

import UIKit

class BonusByMemberTableViewCell: UITableViewCell {

    @IBOutlet weak var memberID: UILabel!
    @IBOutlet weak var memberName: UILabel!
    @IBOutlet weak var commissionThisMonth: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
