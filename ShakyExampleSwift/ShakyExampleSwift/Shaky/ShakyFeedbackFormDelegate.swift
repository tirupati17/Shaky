//
//  FeedbackFormDelegate.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation

public protocol ShakyFeedbackFormDelegate: AnyObject {
    func feedbackFormDidSubmit(_ feedback: ShakyFeedback)
    func feedbackFormDidCancel()
}
