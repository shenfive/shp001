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

    func md5() -> String {
        if let strData = self.data(using: String.Encoding.utf8) {
            var digest = [UInt8](repeating: 0, count:Int(CC_MD5_DIGEST_LENGTH))
    
            strData.withUnsafeBytes {
                CC_MD5($0.baseAddress, UInt32(strData.count), &digest)
            }
            var md5String = ""
            for byte in digest {
                md5String += String(format:"%02x", UInt8(byte))
            }
            return md5String
     
        }
        return ""
    }
    
    
    
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

extension UIImage {
    class func getColoredRectImageWith(color: CGColor, andSize size: CGSize) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        let graphicsContext = UIGraphicsGetCurrentContext()
        graphicsContext?.setFillColor(color)
        let rectangle = CGRect(x: 0.0, y: 0.0, width: size.width, height: size.height)
        graphicsContext?.fill(rectangle)
        let rectangleImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return rectangleImage
    }
}

extension UIView{
    
    //手動自適應 subView 大小
    func aspectFit(insideView:UIView){
        let outSideSize = self.bounds.size
        let inSideSize = insideView.bounds.size
        
        let outSideRatio = outSideSize.width / outSideSize.height
        let inSideRatio = inSideSize.width / inSideSize.height
        
        var targetSize = CGSize()
        var x:CGFloat = 0
        var y:CGFloat = 0
        if outSideRatio <= inSideRatio{
            targetSize = CGSize(width: outSideSize.width , height: outSideSize.width / inSideRatio)
            y = ( outSideSize.height - targetSize.height ) / 2
        }else{
            targetSize = CGSize(width: outSideSize.height * inSideRatio , height: outSideSize.height )
            x = ( outSideSize.width - targetSize.width ) / 2
        }
        insideView.frame = CGRect(origin: CGPoint(x: x, y: y), size: targetSize)
    }
    
    //取得UIView 為 Image
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}

extension CGRect{
    func isPointInside(point:CGPoint)->Bool{
        let theX = point.x - self.origin.x
        let theY = point.y - self.origin.y
        return theX <= self.width && theY <= self.height && theX >= 0 && theY >= 0
    }
}

func timeIntervalToString(timeInterval:TimeInterval,format:String = "yyyy/MM/dd HH:mm:ss") -> String{
    let date = Date.init(timeIntervalSince1970: timeInterval)
    let formatter = DateFormatter()
    formatter.dateFormat = format
    formatter.timeZone = NSTimeZone.local
    return formatter.string(from: date)
}



//計算TextView預設高度
func getTextViewHeight(cellWidth:CGFloat,contentString:String,fontSize:CGFloat)->CGFloat{
   
    let maximumSize = CGSize(width: cellWidth+10, height: 9999)
    let descriptionString = contentString as NSString
    let font = UIFont.systemFont(ofSize: fontSize)
    let descriptionSize = descriptionString.boundingRect(with: maximumSize, options: .usesLineFragmentOrigin, attributes: [kCTFontAttributeName as NSAttributedString.Key: font], context: nil).size
    return descriptionSize.height
}

//檢查 10
func validateCellPhone(_ numString:String)->Bool{
    let passwordRE = "09[0-9]{8}"
    
    let regextestmobile = NSPredicate(format: "SELF MATCHES %@",passwordRE)
    if (regextestmobile.evaluate(with: numString) == true){
        return true
    }else{
        return false
    }
}


