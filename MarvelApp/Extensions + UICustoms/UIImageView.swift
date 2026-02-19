//
//  UIImageView.swift
//  LNJ-Daftar
//
//  Created by Mohamed Ali on 14/02/2024.
//

import UIKit
import SDWebImage
import Combine

extension UIImageView {
    
    func loadImageFromServer(_ url: String, placeHolderName: UIImage = UIImage(named: "loading")!) {
        
        let newUrl = url.trimmingCharacters(in: .whitespaces)
        
        guard let url = URL(string: newUrl) else {
            self.image = UIImage(named: "ErrorConnection")
            return
        }
        
        // Use SDWebImage to load and cache the image
        let placeHolderImage = placeHolderName
        self.sd_setImage(with: url, placeholderImage: placeHolderImage, options: [.refreshCached, .continueInBackground,.transformAnimatedImage]) { [weak self] (image, error, cacheType, imageURL) in
            guard let self = self else { return }
            
            // Handle completion if needed
            if error != nil {
                // Handle error
                self.image = UIImage(named: "ErrorConnection")
            }
        }
        
    }
    
}


extension UIImage {
    static func fromEmoji(_ emoji: String, size: CGFloat) -> UIImage? {
        let label = UILabel()
        label.text = emoji
        label.font = UIFont.systemFont(ofSize: size)
        label.sizeToFit()
        
        UIGraphicsBeginImageContextWithOptions(label.bounds.size, false, 0)
        label.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

// MARK: - UIView + Combine Tap Gesture Publisher
extension UIView {
    
    private class TapGestureSubscription<S: Subscriber>: Subscription where S.Input == Void, S.Failure == Never {
        
        private var subscriber: S?
        private weak var view: UIView?
        private let gesture = UITapGestureRecognizer()
        
        init(subscriber: S, view: UIView) {
            self.subscriber = subscriber
            self.view = view
            
            gesture.addTarget(self, action: #selector(handleTap))
            view.addGestureRecognizer(gesture)
            view.isUserInteractionEnabled = true
        }
        
        func request(_ demand: Subscribers.Demand) {
            // No backpressure needed for gestures
        }
        
        func cancel() {
            subscriber = nil
        }
        
        @objc private func handleTap() {
            _ = subscriber?.receive(())
        }
    }
    
    
    struct TapGesturePublisher: Publisher {
        typealias Output = Void
        typealias Failure = Never
        
        let view: UIView
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Void == S.Input {
            let subscription = TapGestureSubscription(subscriber: subscriber, view: view)
            subscriber.receive(subscription: subscription)
        }
    }
    
    
    /// Public API to get tap publisher
    func tapPublisher() -> TapGesturePublisher {
        return TapGesturePublisher(view: self)
    }
}
