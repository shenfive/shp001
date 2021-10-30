//
//  Tools.swift
//  shp001
//
//  Created by 申潤五 on 2021/10/26.
//

import UIKit


class Tools {
    

    static func currentSevedUser()->[String:Any]{
        if let savedUser = UserDefaults.standard.value(forKey: "currentUser") as? [String:Any]{
            return savedUser
        }
        return [:]
    }
    
    
    //加入
    static func showIndicator(inController:UIViewController){
        let bgView = UIView(frame: inController.view.frame)
        bgView.accessibilityIdentifier = "AnchorGoIndicatioView"
        bgView.backgroundColor = UIColor.black
        bgView.alpha = 0.6
        let indicatorView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        bgView.addSubview(indicatorView)
        indicatorView.color = UIColor.white
        indicatorView.center = bgView.center
        if #available(iOS 13.0, *) {
            indicatorView.style = .large
        } else {
            // Fallback on earlier versions
        }
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        inController.view.addSubview(bgView)
    }
    
    static func removeIndicator(inController:UIViewController){
        for item in inController.view.subviews{
            if item.accessibilityIdentifier == "AnchorGoIndicatioView"{
                item.removeFromSuperview()
            }
        }
    }
    


    
    static func signOut(message:String="成功登出"){
        UserDefaults.standard.removeObject(forKey: "currentUserId")
        UserDefaults.standard.synchronize()
//        value(forKey: "currentUserId")
        let currentVC = Tools.getTopViewController()
        currentVC?.navigationController?.viewControllers[0].dismiss(animated: true, completion: {
            Tools.showToastMessage(message: message, duration: 10)
        })
    }
    
    
    //顯示 Toast 訊息
    static func showToastMessage(message:String,duration:TimeInterval=3){
        let currentVC = Tools.getTopViewController()
        let messageView = ToastMessageView(frame: CGRect(x: 0, y: 0, width: 210, height: 100))
        messageView.messageTextLabel.text = message
        if let center = currentVC?.view.center{
            messageView.center = center
        }
        messageView.resizeToFitMessage()
        currentVC?.view.addSubview(messageView)
    
        var theDuration = duration
        var delay:TimeInterval = 0
        
        if theDuration > 3 {
            delay = theDuration - 3.0
            theDuration -= delay
        }
        delay += 1
        theDuration -= 1
        if theDuration < 0 { theDuration = 0 }
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: theDuration,
                                                       delay: delay,
                                                       options: .curveEaseOut) {
            messageView.alpha = 0
        } completion: { position in
            messageView.removeFromSuperview()
        }
    }

    
    static  func getTopViewController(base: UIViewController? = nil) -> UIViewController? {//取得目前 VC
        var theBase = base
        if theBase == nil {
            let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            theBase = keyWindow?.rootViewController
        }

        if let nav = theBase as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = theBase as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = theBase?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return theBase
    }
}

