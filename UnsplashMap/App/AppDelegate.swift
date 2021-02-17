//
//  AppDelegate.swift
//  UnsplashMapped
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit
import GoogleMaps

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var keys: NSDictionary?
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        configureTabBarAppearance()
        configureNavBarAppearance()
        
        configureKeysPList()
        configureGoogleMapsSDK()
        
        return true
    }
    
    
    private func configureTabBarAppearance() {
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().isTranslucent = false 
        
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UMFont.custom(.medium, 10).font], for: .normal)
    }
    
    
    private func configureNavBarAppearance() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor    = UMColor.lightGrayToBlack
        navBarAppearance.shadowImage        = nil
        navBarAppearance.shadowColor        = nil
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        
        UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UMColor.blackToWhite,                                                                    NSAttributedString.Key.font:            UMFont.h1.font]
        UINavigationBar.appearance().titleTextAttributes      = [NSAttributedString.Key.foregroundColor: UMColor.blackToWhite,                                                                    NSAttributedString.Key.font:            UMFont.h2.font]
    }
    
    
    private func configureKeysPList() {
        if let path = Bundle.main.path(forResource: "keys", ofType: "plist") {
            keys = NSDictionary(contentsOfFile: path)
        }
    }
    
    
    private func configureGoogleMapsSDK() {
        GMSServices.provideAPIKey(UMKeys.Google.apiKey)
    }
    

    //MARK: - UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}

