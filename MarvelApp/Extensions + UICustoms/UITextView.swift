//
//  UITextView.swift
//  Morizone
//
//  Created by Mohamed Ali on 20/11/2025.
//
import UIKit
import Combine

private var placeholderLabelKey: UInt8 = 0

extension UITextView {

    // MARK: - Padding
    func setPadding(_ inset: UIEdgeInsets) {
        self.textContainerInset = inset
    }

    // MARK: - Placeholder
    var placeholder: String? {
        get {
            placeholderLabel?.text
        }
        set {
            if let label = placeholderLabel {
                label.text = newValue
                label.sizeToFit()
            } else {
                addPlaceholder(newValue)
            }
        }
    }

    private var placeholderLabel: UILabel? {
        get { objc_getAssociatedObject(self, &placeholderLabelKey) as? UILabel }
        set { objc_setAssociatedObject(self, &placeholderLabelKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private func addPlaceholder(_ text: String?) {
        let label = UILabel()
        label.text = text
        label.textColor = UIColor.lightGray
        label.font = self.font
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(label)
        self.placeholderLabel = label
        
        // Constraints inside the TextView
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: self.textContainerInset.left + 5),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -(self.textContainerInset.right + 5)),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: self.textContainerInset.top)
        ])

        // Observe text changes
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(textViewDidChange),
            name: UITextView.textDidChangeNotification,
            object: self
        )
    }

    @objc private func textViewDidChange() {
        placeholderLabel?.isHidden = !self.text.isEmpty
    }
    
    func textPublisher() -> AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: Self.textDidChangeNotification, object: self)
            .map { ($0.object as? UITextView)?.text ?? "" }
            .eraseToAnyPublisher()
    }
}
