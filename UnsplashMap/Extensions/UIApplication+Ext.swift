//
//  UIApplication+Ext.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 07.02.21.
//

import UIKit

extension UIApplication {

    static func getTopViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        
        return nil
    }
}
