//
//  AccountManageTableViewCell.swift
//  shp001
//
//  Created by 申潤五 on 2021/11/7.
//

import UIKit

class AccountManageTableViewCell: UITableViewCell {

  
    @IBOutlet weak var detailButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var detailAndSetting:(()->())? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailButton.layer.cornerRadius = 22
    }
    
    @IBAction func detailAndSettingAction(_ sender: Any) {
        detailAndSetting?()
    }
    
}
