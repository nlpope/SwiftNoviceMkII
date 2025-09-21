//  File: NetworkManager.swift
//  Project: SwiftNoviceMkII
//  Created by: Noah Pope on 8/3/25.

import UIKit

class NetworkManager
{
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    
    func fetchCourses(completed: @escaping(Result<[Course], SNError>) -> Void)
    {
        guard let url = URL(string: UrlKeys.baseUrl + UrlKeys.coursesEndpoint)
        else { completed(.failure(.badURL)); return }
        print(url)

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error { completed(.failure(.badResponse)); return }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else { completed(.failure(.badResponse)); return }
            
            guard let data else { completed(.failure(.badData)); return }
            
            do {
                let decoder = JSONDecoder()
                let courses = try decoder.decode([Course].self, from: data)
                completed(.success(courses.sorted { $0.index < $1.index }))
            } catch {
                completed(.failure(.errorDecodingData))
            }
        }
        
        task.resume()
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
