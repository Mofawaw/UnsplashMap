//
//  DarkModeBarButtonItem.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 11.02.21.
//

import UIKit

class DarkModeBarButtonItem: UIBarButtonItem {
    
    let traitCollection: UITraitCollection
    
    
    init(traitCollection: UITraitCollection) {
        self.traitCollection = traitCollection
        
        super.init()
        self.style      = .plain
        self.target     = self
        self.action     = #selector(itemAction)
        self.tintColor  = UMColor.blackToWhite
        
        updateDarkMode()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func updateDarkMode() {
        let window = UIApplication.shared.windows.first!
        
        switch UserDefaultsManager.shared.darkMode {
        case true:
            window.overrideUserInterfaceStyle   = .dark
            image                               = SFSymbol.moon
        case false:
            window.overrideUserInterfaceStyle   = .light
            image                               = SFSymbol.sun
        case nil:
            switch traitCollection.userInterfaceStyle {
            case .light, .unspecified:  UserDefaultsManager.shared.darkMode = false
            case .dark:                 UserDefaultsManager.shared.darkMode = true
            @unknown default: break
            }
            updateDarkMode()
        default: break
        }
    }
    
    
    @objc private func itemAction() {
        let window = UIApplication.shared.windows.first!
        
        switch UserDefaultsManager.shared.darkMode {
        case true:
            window.overrideUserInterfaceStyle   = .light
            UserDefaultsManager.shared.darkMode = false
            image                               = SFSymbol.sun
        case false:
            window.overrideUserInterfaceStyle   = .dark
            UserDefaultsManager.shared.darkMode = true
            image                               = SFSymbol.moon
        default: break
        }
    }
}
