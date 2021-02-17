//
//  UMBodyLabel.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit

class UMBodyLabel: UMLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(font: UMFont, color: Color = .black, alignment: NSTextAlignment = .left) {
        self.init(frame: .zero)
        
        self.font = font.font
        self.textColor = color.color
        self.textAlignment = alignment
    }
    
    
    private func configure() {
        self.adjustsFontSizeToFitWidth          = true
        self.adjustsFontForContentSizeCategory  = true
        self.minimumScaleFactor                 = 0.75
        self.lineBreakMode                      = .byTruncatingTail
        self.numberOfLines                      = 2
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
