//
//  ShakyView.swift
//  ShakyExampleSwift
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import UIKit

public class ShakyView: UIView, FeedbackFormDelegate {
    private var shaky: Shaky
    private var feedbackFormViewController: FeedbackFormViewController?
    
    public init(shakeThreshold: Double = 2, delegate: ShakyDelegate? = nil) {
        self.shaky = Shaky(shakeThreshold: shakeThreshold, delegate: delegate)
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if newSuperview != nil {
            shaky.start()
        } else {
            shaky.stop()
        }
    }
    
    public func shakyDidDetectShake() {
        if feedbackFormViewController == nil {
            feedbackFormViewController = FeedbackFormViewController(delegate: self)
            feedbackFormViewController?.delegate = self
            feedbackFormViewController?.modalPresentationStyle = .formSheet
            if let viewController = parentViewController {
                viewController.present(feedbackFormViewController!, animated: true, completion: nil)
            }
        }
    }
    
    public func shakyDidEndEditing(_ feedback: ShakyFeedback) {
        // Not used in this implementation
    }
    
    public func feedbackFormDidSubmit(_ feedback: ShakyFeedback) {
        feedbackFormViewController?.dismiss(animated: true, completion: {
            self.feedbackFormViewController = nil
            self.shaky.delegate?.shakyDidEndEditing(feedback)
        })
    }
    
    public func feedbackFormDidCancel() {
        feedbackFormViewController?.dismiss(animated: true, completion: {
            self.feedbackFormViewController = nil
        })
    }
}

extension UIView {
    var parentViewController: UIViewController? {
        var responder: UIResponder? = self
        while let nextResponder = responder?.next {
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            responder = nextResponder
        }
        return nil
    }
}
