//
//  ShakyDelegate.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation

public protocol ShakyDelegate: AnyObject {
    func shakyDidSubmit(_ feedback: ShakyFeedback)    
    func shakyDidCancel()
}
