//
//  IntroTableViewCell.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/29.
//

import UIKit

class IntroTableViewCell: UITableViewCell {

    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phneLabel: UILabel!
    var selectedAction:(()->())? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectButton.layer.cornerRadius = 22
    }



    @IBAction func selectAction(_ sender: Any) {
        selectedAction?()
    }
}
