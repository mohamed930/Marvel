//
//  UILabel.swift
//  Morizone
//
//  Created by Mohamed Ali on 31/10/2025.
//

import UIKit

import UIKit
import ObjectiveC

// MARK: - Shared Protocol
protocol SharedAttributes: AnyObject {
    var quicksandWeight: Int { get set }
    func updateQuicksandFont()
}

// MARK: - Shared Default Implementation
extension SharedAttributes where Self: UIView {
    func applyQuicksandFont(to font: UIFont?, weight: Int, setFont: (UIFont) -> Void) {
        let variants = [
            "Quicksand-Bold",       // 0
            "Quicksand-Light",     // 1
            "Quicksand-Medium",    // 2
            "Quicksand-Regular",   // 3
            "Quicksand-SemiBold",  // 4
        ]
        
        let index = max(0, min(weight, variants.count - 1))
        let fontName = variants[index]
        
        if let baseFont = font, let newFont = UIFont(name: fontName, size: baseFont.pointSize) {
            setFont(newFont)
        } else {
            print("⚠️ Font \(fontName) not found. Ensure it's added to Info.plist.")
        }
    }
}

private struct AssociatedKeys {
    static var weightKey = "quicksandWeightKey"
}

//
// MARK: - UILabel Implementation
//
@IBDesignable
extension UILabel: SharedAttributes {
    
    @IBInspectable var quicksandWeight: Int {
        get { objc_getAssociatedObject(self, &AssociatedKeys.weightKey) as? Int ?? 0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.weightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateQuicksandFont()
        }
    }
    
    func updateQuicksandFont() {
        applyQuicksandFont(to: font, weight: quicksandWeight) { self.font = $0 }
    }
}

//
// MARK: - UITextField Implementation
//
@IBDesignable
extension UITextField: SharedAttributes {
    
    @IBInspectable var quicksandWeight: Int {
        get { objc_getAssociatedObject(self, &AssociatedKeys.weightKey) as? Int ?? 0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.weightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateQuicksandFont()
        }
    }
    
    func updateQuicksandFont() {
        applyQuicksandFont(to: font, weight: quicksandWeight) { self.font = $0 }
    }
}

// MARK: - UIButton
@IBDesignable
extension UIButton: SharedAttributes {
    
    @IBInspectable var quicksandWeight: Int {
        get { objc_getAssociatedObject(self, &AssociatedKeys.weightKey) as? Int ?? 0 }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.weightKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            updateQuicksandFont()
        }
    }
    
    func updateQuicksandFont() {
        guard let baseFont = titleLabel?.font else { return }
        applyQuicksandFont(to: baseFont, weight: quicksandWeight) { self.titleLabel?.font = $0 }
    }
}

extension UILabel {
    func setLineHeight(_ height: CGFloat) {
        guard let text = self.text else { return }
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.minimumLineHeight = height
        paragraphStyle.maximumLineHeight = height
        
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSMakeRange(0, attributedString.length))
        
        self.attributedText = attributedString
    }
}
