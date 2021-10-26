//
//  CopyRightViewController.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/27.
//

import UIKit

class CopyRightViewController: UIViewController {

    @IBOutlet weak var forgetPasswordButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        forgetPasswordButton.layer.cornerRadius = 22
        submitButton.layer.cornerRadius = 22
        self.title = "版權聲明"
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
