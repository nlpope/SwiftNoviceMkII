//  File: NetworkManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/3/25.

import UIKit

class NetworkManager
{
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func fetchCourses() async throws
    {
        let urlString = UrlKeys.baseUrl + UrlKeys.coursesEndpoint
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let coursesResponse: [Course] = try await HttpClient
    }
    
    
    func downloadImage(from urlString: String, completed: @escaping (UIImage?) -> Void)
    {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        guard let url = URL(string: urlString) else { return }
        
        // Network Call - where the image is downloaded
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                    completed(nil)
                    return
                  }
                    
            self.cache.setObject(image, forKey: cacheKey)
            completed(image)
        }
        
        task.resume()
    }
}
