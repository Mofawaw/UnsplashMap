//
//  String+Ext.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit

extension String {
    
    func bodyLineSpaced() -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5
        
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
        
        return attributedString
    }
}
