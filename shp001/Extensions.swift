//
//  Extensions.swift
//  AnchorTrack
//
//  Created by 申潤五 on 2021/9/2.
//

import UIKit
import CommonCrypto

extension UIViewController{
    func showAlert(_ message:String,action:((UIAlertAction)->())? = nil){
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "確定", style: .default, handler: action))
        present(alertController, animated: true, completion: nil)
    }
}

extension String{
    func subString(start: Int, end: Int) -> String {
        // 字元長度不足時，可能出現錯誤所以檢查長度, 且不能小於零
        var startL = start
        var endL = end
        if startL > self.count {startL = self.count}
        if startL < 0 {startL = 0}
        if endL > self.count {endL = self.count}
        if endL < 0 {endL = 0}
        let startIndex = String.Index.init(encodedOffset: startL)
        let endIndex = String.Index.init(encodedOffset: endL)
        return String(self[startIndex..<endIndex])
    }
    
    
    func getSringWidth(fontSize: CGFloat) -> CGFloat {
        let font = UIFont.systemFont(ofSize: fontSize)
        
        let rect = NSString(string: self).boundingRect(
            with: CGSize(width: CGFloat(MAXFLOAT), height: fontSize * 2 ),
            options: .usesLineFragmentOrigin,
            attributes: [NSAttributedString.Key.font: font],
            context: nil)
        
        
        return ceil(rect.width)
    }
}

//檢查 10 碼手機號碼
func validateCellPhone(_ numString:String)->Bool{
    let passwordRE = "09[0-9]{8}"
    
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",passwordRE)
    if (regextestmobile.evaluate(with: numString) == true){
        return true
    }else{
        return false
    }
}


//檢查電子郵件格式
func validateEmail(_ str:String)->Bool{
    let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
    let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
    return emailTest.evaluate(with: str)
}


struct Order{
    var key = ""
    var time = Date()
    var poNumber = ""
    var isFirstOrder = false
    var sales = ""
    var productName = ""
    var productNumber = ""
    var qry = 0
    var uniprice = 0
    var disconuntRate = 0.0
    var payMent = ""
    var totalPrice:Int  {
        get {
            return Int(Double( qry * uniprice ) * disconuntRate)
        }
    }
    var intorL1 = ""
    var intorL1Commission = 0.0
    var intorL2 = ""
    var intorL2Commission = 0.0
}
