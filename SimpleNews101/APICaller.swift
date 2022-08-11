//
//  APICaller.swift
//  SimpleNews101
//
//  Created by M. Can Devecioğlu on 11.08.2022.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    struct Constants {
        
        // You should use your own API key from newsapi.org
        // It can be customizable for your country or language
        
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=tr&apiKey=YOUR_API_KEY")
        static let searchUrlString = "https://newsapi.org/v2/top-headlines?country=tr&apiKey=YOUR_API_KEY&q="
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constants.topHeadlinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    public func searcy(with query: String, completion: @escaping (Result<[Article], Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        let urlString = Constants.searchUrlString + query
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    completion(.success(result.articles))
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
}
// Models

struct APIResponse : Codable {
    let articles : [Article]
}

struct Article : Codable {
    let source: Source
    let title : String?
    let description : String?
    let url : String?
    let urlToImage : String?
    let publishedAt : String?
}

struct Source : Codable {
    let name : String
}
