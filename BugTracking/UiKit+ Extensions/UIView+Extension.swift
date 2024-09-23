//
//  UIView+Extension.swift
//  BugTracking
//
//  Created by Khaled Hamed on 07/09/2024.
//

import Foundation
import UIKit

extension UIView {
    
    @objc func addCornerRadius(raduis: CGFloat, borderColor: UIColor?, borderWidth: CGFloat) {
        self.layer.cornerRadius = raduis
        self.layer.masksToBounds = true
        
        if let borderColorValue = borderColor, borderWidth > 0 {
            self.layer.borderColor = borderColorValue.cgColor
            self.layer.borderWidth = borderWidth
        }
    }
}
