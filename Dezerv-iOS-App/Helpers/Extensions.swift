//
//  Extensions.swift
//  Dezerv-iOS-App
//
//  Created by Harsh Kumar Agrawal on 17/04/23.
//

import Foundation
import UIKit

extension Double {
    func roundedStringWithTwoDecimals() -> String {
        return String(format: "%.2f", self)
    }
    func convertNumberToShortString() -> String {
        let absNumber = abs(self)
        let sign = self < 0 ? "-" : ""
        let suffixes = ["", "K", "M", "B"]
        let digits = Int(log10(Double(absNumber)))
        let suffixIndex = (digits / 3)
        let roundedNumber = Double(absNumber) / pow(10, Double(suffixIndex * 3))
        let formattedNumber = String(format: "%.1f", roundedNumber)
        return "\(sign)\(formattedNumber) \(suffixes[suffixIndex])"
    }

}

extension UITableView {
    func dequeueReusableHeaderFooterView<T: UIView>(_ viewClass: T.Type) -> T {
        return self.dequeueReusableHeaderFooterView(withIdentifier: viewClass.getCellIdentifier()) as! T
    }
}

extension UIView {
    
    // MARK: - Class Methods
    class func getNibName() -> String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
    
    class func getCellIdentifier() -> String {
        return getNibName()
    }
}

extension UITableView {
    func registerNib(_ viewClass: UIView.Type) {
        let nib = UINib(nibName: viewClass.getNibName(), bundle: nil)
        register(nib, forCellReuseIdentifier: viewClass.getCellIdentifier())
    }
}

extension UIViewController {
    static func getIdentifier() -> String {
        let className = NSStringFromClass(self).components(separatedBy: ".").last!
        return className
    }
    
    func showAlertController(withTitle title: String?,
                             message: String? = nil,
                             actionTitle: String = "Okay",
                             actionAlertStyle: UIAlertAction.Style = .default,
                             isShowCancel: Bool = false,
                             cancelActionTitle: String = "CANCEL",
                             cancelActionAlertStyle: UIAlertAction.Style = .default,
                             actionHandler: ((UIAlertAction?) -> Void)? = nil,
                             cancelHandler: ((UIAlertAction?) -> Void)? = nil,
                             completion: (() -> Void)? = nil, viewController: UIViewController? = nil, cascadeAlerts: Bool = true) {

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        if isShowCancel {
            alertController.addAction(UIAlertAction(title: cancelActionTitle, style: cancelActionAlertStyle, handler: cancelHandler))
        }

        alertController.addAction(UIAlertAction(title: actionTitle, style: actionAlertStyle, handler: actionHandler))

        if let viewController = viewController {
            viewController.present(alertController, animated: true, completion: nil)
            return
        }

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let sceneDelegate = windowScene.delegate as? SceneDelegate,
           let window = sceneDelegate.window, let vc = window.rootViewController {
            
            if let vc = vc.presentedViewController, vc is UIAlertController, cascadeAlerts {
                alertController.dismiss(animated: false, completion: {
                    vc.present(alertController, animated: true, completion: nil)
                })
            } else {
                vc.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

@IBDesignable
public class CustomUIView: UIView {

    // MARK: - Variable
    private var gShadowOffsetWidth = 0
    private var gShadowOffsetHeight = 0
    
    // MARK: - Initialization
       override init(frame: CGRect) {
           super.init(frame: frame)
           setupView()
       }
       
       required init?(coder: NSCoder) {
           super.init(coder: coder)
       }
       
       // MARK: - UI Setup
       public override func prepareForInterfaceBuilder() {
           setupView()
       }
       
       func setupView() {
           self.layer.cornerRadius = cornerRadius
           self.layer.shadowColor = shadowColor.cgColor
           self.layer.shadowRadius = shadowRadius
           self.layer.shadowOpacity = shadowOpacity
           self.layer.borderWidth = borderWidth
           self.layer.borderColor = borderColor.cgColor
       }
    
    // MARK: - IBInspectables
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var shadowOpacity: Float = 0.0 {
        didSet {
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOpacity = shadowOpacity

            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
            layer.shouldRasterize = true
            layer.rasterizationScale = UIScreen.main.scale
        }
    }

    @IBInspectable var shadowColor: UIColor = .white {
           didSet {
               layer.shadowColor = shadowColor.cgColor
           }
       }
    
    @IBInspectable var shadowRadius: CGFloat = 0.0 {
           didSet {
               layer.shadowRadius = shadowRadius
           }
       }
    
    @IBInspectable var shadowOWidth: Int = 0 {
        didSet {
            gShadowOffsetWidth = shadowOWidth
            layer.shadowOffset = CGSize(width: gShadowOffsetWidth, height: gShadowOffsetHeight)
        }
    }
    
    @IBInspectable var shadowOHeight: Int = 0 {
        didSet {
            gShadowOffsetHeight = shadowOHeight
            layer.shadowOffset = CGSize(width: gShadowOffsetWidth, height: gShadowOffsetHeight)
        }
    }
}

@IBDesignable
class CustomUIButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: - IBInspectables
    @IBInspectable var cornerRadius: CGFloat = 5 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

    @IBInspectable var selectedBorderColor: UIColor = UIColor.clear
    @IBInspectable var disabledBorderColor: UIColor = UIColor.clear

    @IBInspectable var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }

    func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        let writingDirection = UIApplication.shared.userInterfaceLayoutDirection
    }

    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.borderColor = selectedBorderColor.cgColor
                imageView?.tintColor = selectedBorderColor
            } else {
                layer.borderColor = borderColor.cgColor
                imageView?.tintColor = currentTitleColor
            }
        }
    }

    override var isEnabled: Bool {
        didSet {
            if isEnabled {
                layer.borderColor = borderColor.cgColor
            } else {
                layer.borderColor = disabledBorderColor.cgColor
            }
        }
    }
}

extension String {
    func convertToCustomDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: self) else {
            return self
        }
        dateFormatter.dateFormat = "dd/MM"
        return dateFormatter.string(from: date)
    }
}

extension Array {
    subscript (safe index: Int) -> Element? {
        return indices ~= index ? self[index]: nil
    }

    mutating func insertSafe(_ element: Element, at index: Int) {
        if self.count >= index {
            self.insert(element, at: index)
        } else {
            self.insert(element, at: self.count)
        }
    }
}
