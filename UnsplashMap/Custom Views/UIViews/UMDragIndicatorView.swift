//
//  UMDragIndicatorView.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 05.02.21.
//

import UIKit

class UMDragIndicatorView: UIView {
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func configure() {
        frame = CGRect(x: 0, y: 0, width: 60, height: 3)
        backgroundColor = UMColor.lightNeutralToDarkNeutral
        
        layer.masksToBounds = true
        layer.cornerRadius = 1.5
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
