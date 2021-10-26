//
//  ToastMessageView.swift
//  AnchorTrack
//
//  Created by 申潤五 on 2021/9/2.
//

import UIKit

class ToastMessageView: UIView {
    var view:UIView!
    @IBOutlet weak var messageTextLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder) { //一定要寫的建構器
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [ UIView.AutoresizingMask.flexibleWidth,
                                  UIView.AutoresizingMask.flexibleHeight ]
        view.clipsToBounds = true
        view.layer.cornerRadius = 10
        addSubview(view)
    }
    
    func resizeToFitMessage(){
        let msg = messageTextLabel.text ?? ""
        let width = msg.getSringWidth(fontSize: 17) + 40
        let center = self.center
        let rect = CGRect(x: 0, y: 0, width: width, height: 47)
        self.frame = rect
        self.center = center
    }
    
    
    
    func loadViewFromNib() -> UIView {
        let nib = UINib(nibName: "ToastMessageView", bundle: nil )
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
