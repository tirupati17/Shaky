//
//  Shaky.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import UIKit
import CoreMotion

extension Shaky: ShakyFeedbackFormDelegate {
    public func feedbackFormDidSubmit(_ feedback: ShakyFeedback) {
        print("feedbackFormDidSubmit")
        feedbackFormViewController?.dismiss(animated: true, completion: nil)
    }

    public func feedbackFormDidCancel() {
        print("feedbackFormDidCancel")
        feedbackFormViewController?.dismiss(animated: true, completion: nil)
    }
}

public class Shaky: NSObject {

    public weak var delegate: ShakyDelegate?
    public var shakeThreshold: Double

    private var motionManager = CMMotionManager()
    private var lastX: Double = 0.0
    private var lastY: Double = 0.0
    private var lastZ: Double = 0.0
    private var feedbackFormViewController: FeedbackFormViewController?

    public init(shakeThreshold: Double = 1, delegate: ShakyDelegate? = nil) {
        self.shakeThreshold = shakeThreshold
        self.delegate = delegate
    }

    public func start() {
        self.motionManager.accelerometerUpdateInterval = 0.2
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let acceleration = data.acceleration
                let deltaX = abs(self.lastX - acceleration.x)
                let deltaY = abs(self.lastY - acceleration.y)
                let deltaZ = abs(self.lastZ - acceleration.z)

                if deltaX > self.shakeThreshold && deltaY > self.shakeThreshold && deltaZ > self.shakeThreshold {
                    DispatchQueue.main.async {
                        let feedbackForm = FeedbackFormViewController(delegate: self)
                        feedbackForm.delegate = self
                        self.feedbackFormViewController = feedbackForm
                        let rootViewController = UIApplication.shared.windows.first?.rootViewController
                        rootViewController?.present(feedbackForm, animated: true, completion: nil)
                    }
                }

                self.lastX = acceleration.x
                self.lastY = acceleration.y
                self.lastZ = acceleration.z
            }
        }
    }

    public func stop() {
        self.motionManager.stopAccelerometerUpdates()
    }
}
