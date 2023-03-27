//
//  CategoryPickerView.swift
//  Shaky
//
//  Created by Tirupati Balan on 27/03/23.
//

import Foundation
import UIKit

class ShakyCategoryPickerView: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    var selectedCategory: String?
    
    private let categories = [
        "Feature Request",
        "Bug Report",
        "General Feedback"
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.delegate = self
        self.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCategory = self.categories[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
