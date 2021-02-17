//
//  UnsplashNetworkManager.swift
//  UnsplashMap
//
//  Created by Kai Zheng on 02.02.21.
//

import UIKit

final class UnsplashNetworkManager {
    
    static let shared = UnsplashNetworkManager()
    private init() {}
    
    private let baseURL = "https://api.unsplash.com/photos"
    private let id      = "client_id=\(UMKeys.Unsplash.accessKey)"
    
    
    func requestARandomPhotoWithLocation(completion: @escaping (NetworkError?) -> ()) {
        let group = DispatchGroup()
        
        print(">> Request: start")
        DispatchQueue.global().async {            
            var completed = false
            
            repeat {
                group.enter()
                
                print(">> Request: new")
                self.requestRandomPhotos { [weak self] result in
                    guard let self = self else { return }
                    
                    switch result {
                    case let .success(json):
                        if let photo = self.getPhotoWithLocation(fromArray: json) {
                            CoreDataManager.insertPhoto(withDictionary: photo) {
                                completion(nil)
                            }
                            completed = true
                        }
                    case let .failure(error):
                        completion(error)
                        completed = true
                    }
                    
                    group.leave()
                }
                
                group.wait()
                if !completed { sleep(1) } //Necessary, otherwise same photo again
                
            } while !completed
        }
    }
    
    
    private func getPhotoWithLocation(fromArray json: JSONArray) -> JSONDictionary? {
        for photo in json {
            if let photo = photo as? JSONDictionary {
                if let location = photo["location"] as? JSONDictionary {
                    if let position = location["position"] as? JSONDictionary {
                        if position["latitude"] is Double, position["longitude"] is Double {
                            print(photo["id"] ?? "")
                            return photo
                        } else {
                            print(">> Request: no location")
                        }
                    }
                }
            }
        }
        
        return nil
    }
    
    
    private func requestRandomPhotos(completion: @escaping (Result<JSONArray, NetworkError>) -> ()) {
        let urlString = baseURL + "/random?count=5&" + id
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.unknown))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                completion(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSONArray {
                        completion(.success(json))
                    }
                    
                } catch {
                    completion(.failure(.unknown))
                    return
                }
                
            } else {
                completion(.failure(.unknown))
                return
            }
        }

        task.resume()
    }
}
