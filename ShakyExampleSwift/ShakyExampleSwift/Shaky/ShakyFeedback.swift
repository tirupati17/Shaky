//
//  ShakyFeedback.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import UIKit

public struct ShakyFeedback {
    public let description: String
    public let category: String
    public let image: UIImage?
    
    public init(description: String, category: String, image: UIImage?) {
        self.description = description
        self.category = category
        self.image = image
    }
}
