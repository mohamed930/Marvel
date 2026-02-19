//
//  EventPublisher.swift
//  Morizone
//
//  Created by Mohamed Ali on 31/10/2025.
//


import Combine
import UIKit

extension UIControl {
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(subscriber: subscriber, control: control, event: event)
            subscriber.receive(subscription: subscription)
        }
        
        private final class EventSubscription<S: Subscriber>: Subscription where S.Input == UIControl {
            private var subscriber: S?
            weak private var control: UIControl?
            let event: UIControl.Event
            
            init(subscriber: S, control: UIControl, event: UIControl.Event) {
                self.subscriber = subscriber
                self.control = control
                self.event = event
                control.addTarget(self, action: #selector(eventHandler), for: event)
            }
            
            func request(_ demand: Subscribers.Demand) { }
            
            func cancel() {
                subscriber = nil
            }
            
            @objc private func eventHandler() {
                _ = subscriber?.receive(control!)
            }
        }
    }
    
    func publisher(for event: UIControl.Event) -> EventPublisher {
        return EventPublisher(control: self, event: event)
    }
}
