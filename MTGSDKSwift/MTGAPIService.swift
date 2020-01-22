//
//  MTGAPIService.swift
//  mtg-sdk-swift
//
//  Created by Reed Carson on 2/24/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import Foundation

public typealias JSONResults = [String:Any]
public typealias JSONCompletionWithError = (Swift.Result<JSONResults, NetworkError>) -> Void

final class MTGAPIService {

    /// Performs A query against the MTG APIs and calls back to the provided completion handler
    /// with a success or failure.
    ///
    /// - Parameters:
    ///   - url: The MTG URL to hit.
    ///   - completion: The completion handler block to handle the response.
    func mtgAPIQuery(url: URL, completion: @escaping JSONCompletionWithError) {
        let networkOperation = NetworkOperation(url: url)
        networkOperation.performOperation {
            result in
            switch result {
            case .success(let json):
                completion(Result.success(json))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

final private class NetworkOperation {
    
    let session: URLSession = {
        return URLSession(configuration: URLSessionConfiguration.default)
    }()
    
    let url: URL
    
    init(url: URL) {
        self.url = url
    }
    
    func performOperation(completion: @escaping JSONCompletionWithError) {        
        let request = URLRequest(url: url)
        let dataTask = session.dataTask(with: request) { data, response, error in

            if let error = error {
                return completion(.failure(NetworkError.requestError(error)))
            }

            guard let data = data else {
                return completion(.failure(NetworkError.miscError("Network operation - No data returned")))
            }

            if let httpResponse = (response as? HTTPURLResponse) {
                debugPrint("MTGSDK HTTPResponse - status code: \(httpResponse.statusCode)")
            
                switch httpResponse.statusCode {
                case 200..<300:
                    break
                default:
                    return completion(.failure(NetworkError.unexpectedHTTPResponse(httpResponse)))
                }
            }
            
            do {
                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                guard let json = jsonResponse as? JSONResults else {
                    return completion(.failure(NetworkError.miscError("Network operation - invalid json response")))
                }
                completion(.success(json))
            } catch {
                completion(.failure(NetworkError.miscError("json serialization error")))
            }
        }
        
        dataTask.resume()
    }
}

