//
//  Client.swift
//  MovieSearch
//
//  Created by Frank Mortensen on 28/09/2019.
//  Copyright © 2019 Frank Mortensen. All rights reserved.
//

import Foundation

class MovieDBClient {
    
    enum Endpoints {
        static let base = "https://api.themoviedb.org/3"
        
        case search(String)
        case genres
        case thumbnailImage(String)
    
        var stringValue: String {
            switch self {
                case .search(let query):
                    return "\(Endpoints.base)/search/movie\(apiSuffix)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
                
                case .genres:
                    return "\(Endpoints.base)/genre/movie/list\(apiSuffix)&language=en-US"
                
                case .thumbnailImage(let posterPath):
                    return "https://image.tmdb.org/t/p/w185/" + posterPath
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
        var apiSuffix: String {
            get {
                let secrets = getSecrets()
                return "?api_key=\(secrets.apiKey)"
            }
        }

    }
    
    class func getGenres(completion: @escaping ([Genre], Error?) -> Void) -> URLSessionTask {
        
        let task = taskForGETRequest(
            url: Endpoints.genres.url,
            responseType: GenreResults.self
        ) { (response, error) in
            
            if let response = response {
                completion(response.genres, nil)
            } else {
                completion([], error)
            }
            
        }
        
        return task
        
    }
    
    class func searchMovies(query: String, completion: @escaping ([Movie], Error?) -> Void) -> URLSessionTask {
        
        let task = taskForGETRequest(
            url: Endpoints.search(query).url,
            responseType: MovieResults.self
        ) {(response, error) in
            
            if let response = response {
                completion(response.results, nil)
            } else {
                completion([], error)
            }
            
        }
        
        return task
        
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(
        url: URL,
        responseType: ResponseType.Type,
        completion: @escaping (ResponseType?, Error?) -> Void
        ) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(MovieDBResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        
        task.resume()
        
        return task
    }
    
    
    class func getSecrets() -> Secrets {
        
        guard
            let path = Bundle.main.path(
                forResource: "Secrets",
                ofType: "plist"
            )
        else {
            fatalError("Missing resources/Secrets!")
        }
        
        let secrets = NSDictionary(contentsOfFile: path)
            
        guard
            let apiKey = secrets?.value(forKey: "API_KEY") as? String
        else {
            fatalError("Could not find key API_KEY in Secrets!")
        }
            
        return Secrets(apiKey: apiKey)
    }
    
    class func downloadThumbnailImage(path: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.thumbnailImage(path).url) { data, response, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
        task.resume()
    }
}

struct Secrets {
    var apiKey: String
}
