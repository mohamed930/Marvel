//
//  UIView.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 10/02/2024.
//

import UIKit
import Combine

extension UIView {
    
    func setCornerRadious(value: CGFloat, mask: CACornerMask? = nil) {
        self.layer.cornerRadius = value
        self.layer.masksToBounds = true
        
        if let mask = mask {
            self.layer.maskedCorners = mask
        }
    }
    
    func loadViewFromNib (nibName: String) -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate (withOwner: self, options: nil).first as? UIView
    }
    
    func applyGradient(startColor: UIColor, endColor: UIColor, cornerRadius: CGFloat) {
        let colorTop = startColor.cgColor
        let colorBottom = endColor.cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors  = [colorTop,colorBottom]
        gradientLayer.locations = [0.0,1.0]


        // Apply the shape layer as the mask
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
        self.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        
        // Set the frame of the gradient layer to match the view
        
        
        // Ensure that the gradient layer extends to the edges of the view
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        self.isOpaque = false
        self.clipsToBounds = true

        self.backgroundColor = .clear
        
        gradientLayer.frame = self.frame
        
        // Add the gradient layer to the view
        self.layer.insertSublayer(gradientLayer, at: 0) // Add at index 0 for better rendering
    }
    
    func addGeusterToView() -> AnyPublisher<UIGestureRecognizer.State,Never> {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        self.isUserInteractionEnabled = true
        
        self.addGestureRecognizer(tap)
        
        return tap.publisher(for: \.state).eraseToAnyPublisher()
    }
    
}

private var goneConstraintKey: UInt8 = 0

extension UIView {

    enum Visibility: String {
        case visible
        case invisible
        case gone
    }

    // MARK: - Associated Object Key
    private static let goneConstraintKey = UnsafeRawPointer(bitPattern: "goneConstraintKey".hashValue)!

    private var goneConstraint: NSLayoutConstraint? {
        get {
            objc_getAssociatedObject(self, UIView.goneConstraintKey) as? NSLayoutConstraint
        }
        set {
            objc_setAssociatedObject(
                self,
                UIView.goneConstraintKey,
                newValue,
                .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            )
        }
    }

    // MARK: - Visibility API
    var visibility: Visibility {
        get {
            if let constraint = goneConstraint, constraint.isActive {
                return .gone
            }
            return isHidden ? .invisible : .visible
        }
        set {
            setVisibility(newValue)
        }
    }

    // MARK: - IBInspectable (Storyboard Support)
    @IBInspectable
    var visibilityState: String {
        get {
            visibility.rawValue
        }
        set {
            guard let state = Visibility(rawValue: newValue.lowercased()) else {
                return
            }
            visibility = state
        }
    }

    // MARK: - Internal Handler
    private func setVisibility(_ visibility: Visibility) {

        guard let superview = superview else {
            isHidden = (visibility != .visible)
            return
        }

        switch visibility {

        case .visible:
            goneConstraint?.isActive = false
            isHidden = false

        case .invisible:
            goneConstraint?.isActive = false
            isHidden = true

        case .gone:
            isHidden = true

            if goneConstraint == nil {
                let constraint = heightAnchor.constraint(equalToConstant: 0)
                constraint.priority = .required
                goneConstraint = constraint
            }
            goneConstraint?.isActive = true
        }

        // 🔥 Force layout update
        superview.setNeedsLayout()
        superview.layoutIfNeeded()
    }
}



extension UIView {
    func enableAutoLayout() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func matchParentView(parentView: UIView, horizontalMargin: CGFloat = 0, verticalMargin: CGFloat = 0){
        parentView.addSubview(self)
        topAnchor.constraint(equalTo: parentView.topAnchor, constant: verticalMargin)
            .isActive = true
        bottomAnchor.constraint(equalTo: parentView.bottomAnchor, constant: -verticalMargin)
            .isActive = true
        leadingAnchor.constraint(equalTo: parentView.leadingAnchor, constant: horizontalMargin)
            .isActive = true
        trailingAnchor.constraint(equalTo: parentView.trailingAnchor, constant: -horizontalMargin)
            .isActive = true

    }
    
    func anchorWidth(equalToConstant: CGFloat)  {
        widthAnchor.constraint(equalToConstant: equalToConstant)
            .isActive = true
    }
    func anchorHeight(equalToConstant: CGFloat)  {
        heightAnchor.constraint(equalToConstant: equalToConstant)
            .isActive = true
    }
    
    func anchorXAxis(leading:NSLayoutXAxisAnchor? = nil, trailing:NSLayoutXAxisAnchor? = nil, leadingConstant: CGFloat = 0, trailingConstant: CGFloat = 0) {
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: leadingConstant)
                .isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: trailingConstant)
                .isActive = true
        }
    }
    
    func anchorYAxis(top:NSLayoutYAxisAnchor? = nil, bottom:NSLayoutYAxisAnchor? = nil, topConstant: CGFloat = 50, bottomConstant: CGFloat = 0) {
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: topConstant)
                .isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: bottomConstant)
                .isActive = true
        }
    }
}
