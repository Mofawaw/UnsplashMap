//
//  UMLabel.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit

class UMLabel: UILabel {
    
    enum Color {
        case black, white
        
        var color: UIColor {
            switch self {
            case .black:    return UMColor.blackToWhite
            case .white:    return UMColor.whiteToBlack
            }
        }
    }
}
