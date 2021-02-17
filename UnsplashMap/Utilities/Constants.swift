//
//  Constants.swift
//  UnsplashMapped
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

enum UMLayout {
    
    static let padding: CGFloat             = 20
    static let screenWidth: CGFloat         = UIScreen.main.bounds.size.width
    static let screenHeight: CGFloat        = UIScreen.main.bounds.size.height
    
    static func onlyOniPhoneXType(_ value: CGFloat) -> CGFloat {
        return Device.isiPhoneXType ? value : 0
    }
}


enum Device {
        
    static let idiom                        = UIDevice.current.userInterfaceIdiom
    static let nativeScale                  = UIScreen.main.nativeScale
    static let scale                        = UIScreen.main.scale
    
    static let isiPhoneSE                   = idiom == .phone && UMLayout.screenHeight == 568.0
    static let isiPhone8Standard            = idiom == .phone && UMLayout.screenHeight == 667.0 && nativeScale == scale
    static let isiPhone8Zoomed              = idiom == .phone && UMLayout.screenHeight == 667.0 && nativeScale > scale
    static let isiPhone8PlusStandard        = idiom == .phone && UMLayout.screenHeight == 736.0
    static let isiPhone8PlusZoomed          = idiom == .phone && UMLayout.screenHeight == 736.0 && nativeScale < scale
    static let isiPhoneXAnd11And12Mini      = idiom == .phone && UMLayout.screenHeight == 812.0
    static let isiPhoneXsMaxAndXrAnd11Max   = idiom == .phone && UMLayout.screenHeight == 896.0
    static let isiPhone12                   = idiom == .phone && UMLayout.screenHeight == 844.0
    static let isiPhone12ProMax             = idiom == .phone && UMLayout.screenHeight == 926.0

    static private let isiPhone12Type: Bool = { return isiPhone12 || isiPhone12ProMax }()
    static let isiPhoneXType: Bool = { return isiPhoneXAnd11And12Mini || isiPhoneXsMaxAndXrAnd11Max || isiPhone12Type }()
}


enum UMColor {
    
    static let whiteToBlack                 = UIColor(named: "WhiteToBlack")!
    static let whiteToDarkGray              = UIColor(named: "WhiteToDarkGray")!
    static let lightGrayToBlack             = UIColor(named: "LightGrayToBlack")!
    static let lightGrayToDarkGray          = UIColor(named: "LightGrayToDarkGray")!
    static let blackToWhite                 = UIColor(named: "BlackToWhite")!
    static let lightNeutralToDarkNeutral    = UIColor(named: "LightNeutralToDarkNeutral")!
    static let backgroundOpacity            = UIColor.black.withAlphaComponent(0.4)
}


enum SFSymbol {
    
    private static let small                = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 17, weight: .light))
    private static let big                  = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20, weight: .light))
    
    static let photo                        = UIImage(systemName: "photo",                  withConfiguration: small)!
    static let photoFill                    = UIImage(systemName: "photo.fill",             withConfiguration: small)!
    static let map                          = UIImage(systemName: "map",                    withConfiguration: small)!
    static let mapFill                      = UIImage(systemName: "map.fill",               withConfiguration: small)!
    static let location                     = UIImage(systemName: "mappin.and.ellipse",     withConfiguration: big)!
    static let plus                         = UIImage(systemName: "plus",                   withConfiguration: big)!
    static let currentLocation              = UIImage(systemName: "location",               withConfiguration: small)!
    static let globe                        = UIImage(systemName: "globe",                  withConfiguration: small)!
    static let xmark                        = UIImage(systemName: "xmark",                  withConfiguration: small)!
    static let trash                        = UIImage(systemName: "trash",                  withConfiguration: small)!
    static let checkmark                    = UIImage(systemName: "checkmark",              withConfiguration: small)!
    static let arrowDown                    = UIImage(systemName: "chevron.down",           withConfiguration: small)!
    static let sun                          = UIImage(systemName: "sun.max",                withConfiguration: small)!
    static let moon                         = UIImage(systemName: "moon",                   withConfiguration: small)!
}


enum UMFont {
    
    case h1, h2, h3, body, custom(Raleway, CGFloat)

    var font: UIFont {
        switch self {
        case .h1:   return UIFont(name: Raleway.extraBold.weight,    size: 40)!
        case .h2:   return UIFont(name: Raleway.bold.weight,         size: 17)!
        case .h3:   return UIFont(name: Raleway.medium.weight,       size: 25)!
        case .body: return UIFont(name: Raleway.light.weight,        size: 18)!
        case let .custom(name, size): return UIFont(name: name.weight, size: size)!
        }
    }
}


enum Raleway: String {

    case extraBold                          = "Raleway-ExtraBold"
    case bold                               = "Raleway-Bold"
    case semiBold                           = "Raleway-SemiBold"
    case medium                             = "Raleway-Medium"
    case regular                            = "Raleway-Regular"
    case light                              = "Raleway-Light"
    case extraLight                         = "Raleway-ExtraLight"
    case thin                               = "Raleway-Thin"
    
    var weight: String { return self.rawValue }
}


enum UMKeys {
    
    static private let appDelegate          = (UIApplication.shared.delegate as! AppDelegate)
    
    enum Unsplash {
        static let accessKey                = appDelegate.keys?["unsplash_accessKey"] as? String ?? ""
        static let secretKey                = appDelegate.keys?["unsplash_secretKey"] as? String ?? ""
    }
    
    enum Google {
        static let apiKey                   = appDelegate.keys?["google_apiKey"] as? String ?? ""
    }
}


enum UMBundle {
    
    static let defaultMapStyle              = Bundle.main.url(forResource: "defaultMapStyle", withExtension: "json")
    static let defaultDarkMapStyle          = Bundle.main.url(forResource: "defaultDarkMapStyle", withExtension: "json")
}
