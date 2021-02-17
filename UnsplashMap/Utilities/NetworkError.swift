//
//  NetworkError.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import Foundation

enum NetworkError: String, Error {
    
    case unableToComplete   = "Unable to complete your request. Please check your internet connection"
    case invalidResponse    = "Invalid response from the server. Please try again."
    case unknown            = "An unknown error occured. You may try restarting the app."
    case timeout            = "Timeout. Please try again."
    
    var message: String { return self.rawValue }
}
