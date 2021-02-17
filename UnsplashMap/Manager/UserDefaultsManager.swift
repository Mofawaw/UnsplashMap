//
//  UserDefaultsManager.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 07.02.21.
//

import Foundation

final class UserDefaultsManager {
    
    static let shared = UserDefaultsManager()
    private init() {}

    @UserDefault(UserDefaultKey.firstStart, default: true)  var firstStart: Bool
    @UserDefault(UserDefaultKey.darkMode,   default: nil)   var darkMode: Bool?
}


@propertyWrapper
struct UserDefault<T> where T: Codable {
    
    let key: UserDefaultKey
    let defaultValue: T
    
    init(_ key: UserDefaultKey, default: T) {
        self.key = key
        self.defaultValue = `default`
    }

    var wrappedValue: T {
        get { UserDefaults.standard.value(forKey: key.rawValue) as? T ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key.rawValue) }
    }
}


struct UserDefaultKey: RawRepresentable {
    
    let rawValue: String
}


extension UserDefaultKey: ExpressibleByStringLiteral {
    
    init(stringLiteral: String) {
        rawValue = stringLiteral
    }
}


extension UserDefaultKey {
    
    typealias Key = UserDefaultKey
    
    static let firstStart: Key  = "firstStart"
    static let darkMode: Key    = "darkMode"
}
