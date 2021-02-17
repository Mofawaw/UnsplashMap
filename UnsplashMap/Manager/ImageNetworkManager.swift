//
//  ImageNetworkManager.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 03.02.21.
//

import UIKit

final class ImageNetworkManager {
    
    static let shared = ImageNetworkManager()
    private init() {}
    
    let cache = NSCache<NSString, UIImage>()
    
    
    func requestImage(fromURLString urlString: String, completion: @escaping (UIImage) -> ()) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { return }
            
            if let data = data {
                guard let image = UIImage(data: data) else { return }
                self.cache.setObject(image, forKey: cacheKey)
                
                DispatchQueue.main.async {
                    completion(image)
                }
            }
        }
        
        task.resume()
    }
}
