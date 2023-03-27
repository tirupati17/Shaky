//
//  ShakeMotionManager.swift
//  ShakyExampleSwift
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import CoreMotion

public class ShakeMotionManager {
    private var motionManager: CMMotionManager
    private var motionUpdateBlock: (() -> Void)?
    private var threshold: Double
    
    public init(motionManager: CMMotionManager = CMMotionManager(), threshold: Double = 2) {
        self.motionManager = motionManager
        self.threshold = threshold
    }
    
    public func startUpdates(withThreshold threshold: Double, updateBlock: (() -> Void)?) {
        self.motionUpdateBlock = updateBlock
        self.threshold = threshold
        
        self.motionManager.startAccelerometerUpdates(to: OperationQueue.main) { [weak self] (data, error) in
            guard let self = self else { return }
            if let error = error {
                print("Error reading accelerometer data: \(error.localizedDescription)")
                return
            }
            
            let acceleration = data!.acceleration
            let magnitude = sqrt(pow(acceleration.x, 2) + pow(acceleration.y, 2) + pow(acceleration.z, 2))
            
            if magnitude > self.threshold {
                self.motionUpdateBlock?()
            }
        }
    }
    
    public func stopUpdates() {
        self.motionManager.stopAccelerometerUpdates()
    }
}
