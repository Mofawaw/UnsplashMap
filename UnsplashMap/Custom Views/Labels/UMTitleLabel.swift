//
//  UMTitleLabel.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

class UMTitleLabel: UMLabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    convenience init(font: UMFont, color: Color = .black) {
        self.init(frame: .zero)
        
        self.font = font.font
        self.textColor = color.color
    }
    
    
    private func configure() {
        self.adjustsFontSizeToFitWidth   = true
        self.minimumScaleFactor          = 0.9
        self.lineBreakMode               = .byTruncatingTail
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}
