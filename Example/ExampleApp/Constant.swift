//
//  Constant.swift
//  level777
//
//  Created by TBI-iOS-02 on 23/03/20.
//  Copyright © 2020 TBI-iOS-02. All rights reserved.
//

import UIKit
import AVFoundation
import NVActivityIndicatorView
import Alamofire

let DefaultAnimationDuration: TimeInterval        = 0.3

var window: UIWindow?
public let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
public let authStoryboard = UIStoryboard(name: "Authentication", bundle: nil)
public let profileStoryboard = UIStoryboard(name: "Profile", bundle: nil)

public typealias JSONArray = [[String : Any]]
public typealias JSONDictionary = [String : Any]
public let ScreenHeight = UIScreen.main.bounds.height
public let ScreenWidth = UIScreen.main.bounds.width
public var LoadeSize = CGSize(width: 45, height: 45)
//public var profileData = NSMutableDictionary()
public var placeholderImg = UIImage(named: "")


//MARK: - Colors
extension UIColor {
    
    static var appBlueColor = UIColor.init(named: "DarkBlueColor")!
        static var appLightGrayColor = UIColor.init(named: "lightGrayBorderColor")!
    
    static var appMediumGrayColor = UIColor(named: "TintColor") ?? .black
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
    static func hexStringToUIColor(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
   
//MARK: - Fonts
enum themeFonts : String {
    
    case bold = "Helvetica-Bold"
    case regular = "HelveticaNeue"
    case medium = "HelveticaNeue-Medium"
}

func themeFont(size : Float,fontname : themeFonts) -> UIFont {
    
    if UIScreen.main.bounds.width <= 320 {
        return UIFont(name: fontname.rawValue, size: CGFloat(size) - 2.0)!
    }
    else {
        return UIFont(name: fontname.rawValue, size: CGFloat(size))!
    }
}



extension UIViewController {
    private struct AssociatedKeys {
        static var activityIndicator: NVActivityIndicatorView?
    }

    private var activityIndicator: NVActivityIndicatorView? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.activityIndicator) as? NVActivityIndicatorView
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.activityIndicator, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    func start_loading() {
        guard activityIndicator == nil else {
            return // Indicator already visible, no need to create another one.
        }

        let frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        let color = UIColor.blue // Change this to your desired color
        let indicator = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: color, padding: nil)
        indicator.translatesAutoresizingMaskIntoConstraints = false

        if let view = self.view {
            view.addSubview(indicator)
            indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }

        activityIndicator = indicator
        activityIndicator?.startAnimating()
    }

    func stop_loading() {
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
    }
}







class Constant: NSObject
{
    static let SCREEN_WIDTH  = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
    
    static let appDeleate : AppDelegate = UIApplication.shared.delegate as! AppDelegate
    static let screenSize               = UIScreen.main.bounds.size
    
    //Mark:
    static let backgoundColor   : UIColor   = UIColor.white
    static let theme_color      : UIColor   = #colorLiteral(red: 0.08235294118, green: 0.08235294118, blue: 0.0862745098, alpha: 1) //UIColor(red: 248.0/255.0, green: 160.0/255.0, blue: 10.0/255.0, alpha: 1.0)
    
    static let logo_White       : UIImage   = UIImage(named: "fpEmail")!
    static let logo_Colored     : UIImage   = UIImage(named: "fpEmail")!
    


    static var selectedThemeId: Int = UserDefaults.standard.integer(forKey: "theme")
    static let iapSharedSecret = "a9e6eca345f04d0fa3b513e159d91347"
   
    
}



extension String {
    public static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
    
    func getQueryStringParameter(_ param: String) -> String? {
        if let urlComponents = URLComponents(string: self), let queryItems = urlComponents.queryItems {
            return queryItems.filter({ (item) in item.name == param }).first?.value!
        }
        return nil
    }
}

extension UIView {
    func presentWithForwardAnimation() {
        self.alpha = 0
        self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        UIView.animate(withDuration: DefaultAnimationDuration, animations: {
            self.transform = CGAffineTransform.identity
            self.alpha = 1
        })
    }
    
    func dismissWithBackwardAnimation() {
        self.alpha = 1
        UIView.animate(withDuration: DefaultAnimationDuration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.alpha = 0
        }, completion: { (completed) in
            self.transform = CGAffineTransform.identity
        })
    }
}

extension CAAnimation {
    
    static func opacityAnimation(withDuration duration: Double, initialValue: Float, finalValue: Float) -> CAAnimation {
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.duration = duration
        opacityAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        opacityAnimation.fromValue = initialValue
        opacityAnimation.toValue = finalValue

        return opacityAnimation
    }
    
}
extension UIView {
  func addDashedBorder() {
      let color = UIColor(named: "DarkBlueColor")?.withAlphaComponent(0.8).cgColor // Add opacity of 0.8 to the color

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
    shapeLayer.fillColor = UIColor.clear.cgColor
      shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 1
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [2,2]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 4).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}

extension String {
    func isValidEmail() -> Bool {
           let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
           let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return emailPredicate.evaluate(with: self)
       }
   
}

extension Notification.Name{
    static let ReloadTab = Notification.Name("ReloadTab")
    static let ReloadIndex = Notification.Name("ReloadIndex")
    static let ReloadController = Notification.Name("ReloadController")
    static let ReloadFamilyMember = Notification.Name("ReloadFamilyMember")
}
