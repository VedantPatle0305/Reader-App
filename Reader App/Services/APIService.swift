//
//  APIService.swift
//  Reader App
//
//  Created by Vedant Patle on 15/09/25.
//

import Foundation

class APIService {
    static let shared = APIService()
    private init() {}
    
    func fetchArticles(completion: @escaping (Result<[Article], Error>) -> Void){
        
        let date = Calendar.current.date(byAdding: .month, value: -1, to: Date())?.toAPIDateFormat() ?? Date().toAPIDateFormat()
        
        let urlString = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=1f338052353b475da09252958b298442"
        
        print(urlString)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "NO Data", code: 0)))
                return
            }
            
            do{
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(NewsResponse.self, from: data)
                print(decoded.articles)
                completion(.success(decoded.articles))
            }
            catch{
                completion(.failure(error))
            }
            
        }
        task.resume()
        
    }
}

extension Date {
    func toAPIDateFormat() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
}
