//
//  UMCircleButton.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

class UMCircleButton: UMScaleButton {
    
    init(size: Size, appearance: Appearance, symbol: UIImage) {
        super.init(frame: .zero)
        configure(size: size, appearance: appearance, symbol: symbol)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure(size: Size, appearance: Appearance, symbol: UIImage) {
        self.frame = CGRect(x: 0, y: 0, width: size.diameter, height: size.diameter)
        self.layer.cornerRadius = size.radius
        self.clipsToBounds = true
        
        self.contentMode = .scaleAspectFill
        
        self.setImage(symbol, for: .normal)
        self.imageEdgeInsets = UIEdgeInsets(with: size.edgeInsets)
        
        self.tintColor = appearance.tintColor
        self.backgroundColor = appearance.backgroundColor
        
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


extension UMCircleButton {
    
    enum Size {
        
        case small, medium, large
        
        var diameter: CGFloat {
            switch self {
            case .small:    return 35
            case .medium:   return 50
            case .large:    return 65
            }
        }
        
        var radius: CGFloat { return diameter / 2 }
        
        var edgeInsets: CGFloat {
            switch self {
            case .small:    return 10
            case .medium:   return 15
            case .large:    return 20
            }
        }
    }
    
    
    enum Appearance {
        
        case light, dark
        
        var backgroundColor: UIColor {
            switch self {
            case .light:    return UMColor.lightGrayToBlack
            case .dark:     return UMColor.blackToWhite
            }
        }
        
        var tintColor: UIColor {
            switch self {
            case .light:    return UMColor.blackToWhite
            case .dark:     return UMColor.whiteToBlack
            }
        }
    }
}
