//
//  MagicalCardManager.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 3/1/17.
//  Copyright © 2017 Reed Carson. All rights reserved.
//

import UIKit

final public class Magic {
    public typealias CardImageCompletion = (Result<UIImage, NetworkError>) -> Void
    public typealias CardCompletion = (Result<[Card], NetworkError>) -> Void
    public typealias SetCompletion = (Result<[CardSet], NetworkError>) -> Void

    /// Should the Magic API log messages to the `print` function?  Defaults to true.
    public static var enableLogging = true

    private let mtgAPIService = MTGAPIService()
    
    /// Default initialization
    public init() { }

    /// Reteives an array of Cards which match the parameters given.
    /// See https://docs.magicthegathering.io/#api_v1cards_list for more info.
    ///
    /// - Parameters:
    ///   - parameters: The Card Search Parameters that you'd like to search with.
    ///   - configuration: The Search Configuration (defaults to `.defaultConfiguration`).
    ///   - completion: The completion handler (for success / failure response).
    public func fetchCards(_ parameters: [CardSearchParameter],
                           configuration: MTGSearchConfiguration = .defaultConfiguration,
                           completion: @escaping CardCompletion) {
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            return completion(.failure(NetworkError.miscError("fetchCards url build failed")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url) { result in
            switch result {
            case .success(let json):
                let cards = Parser.parseCards(json: json)
                completion(.success(cards))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Reteives an array of CardSet which matches the parameters given.
    /// See https://docs.magicthegathering.io/#api_v1sets_list for more info.
    ///
    /// - Parameters:
    ///   - parameters: The Card Set search parameters you want to search for.
    ///   - configuration: The Search Configuration, defaults to `.defaultConfiguration`.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchSets(_ parameters: [SetSearchParameter],
                          configuration: MTGSearchConfiguration = .defaultConfiguration,
                          completion: @escaping SetCompletion) {
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            return completion(.failure(NetworkError.miscError("fetchSets url build failed")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url) { result in
            switch result {
            case .success(let json):
                let sets = Parser.parseSets(json: json)
                completion(.success(sets))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Fetch JSON returns the raw json data rather than an Array of Card or CardSet. It will return json
    /// for sets or cards depending on what you feed it.
    ///
    /// - Parameters:
    ///   - parameters: either [CardSearchParameter] or [SetSearchParameter]
    ///   - configuration: The Search Configuration, defaults to `.defaultConfiguration`.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchJSON(_ parameters: [SearchParameter],
                          configuration: MTGSearchConfiguration = .defaultConfiguration,
                          completion: @escaping JSONCompletionWithError) {
        
        guard let url = URLBuilder.buildURLWithParameters(parameters, andConfig: configuration) else {
            return completion(.failure(NetworkError.miscError("fetchJSON url build failed")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url) { result in
            switch result {
            case .success:
                completion(result)

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    /// Retreives a UIImage based on the imageURL of the Card passed in
    ///
    /// - Parameters:
    ///   - card: The card you wish to get the image for.
    ///   - completion: The completion handler (for success / failure response).
    public func fetchImageForCard(_ card: Card, completion: @escaping CardImageCompletion) {
        guard let imgurl = card.imageUrl else {
            return completion(.failure(NetworkError.fetchCardImageError("fetchImageForCard card imageURL was nil")))
        }
        
        guard let url = URL(string: imgurl) else {
            return completion(.failure(NetworkError.fetchCardImageError("fetchImageForCard url build failed")))
        }
        
        do {
            let data = try Data(contentsOf: url)
            guard let img = UIImage(data: data) else {
                return completion(.failure(NetworkError.fetchCardImageError("could not create uiimage from data")))
            }
            completion(.success(img))
        } catch {
            completion(.failure(NetworkError.fetchCardImageError("data from contents of url failed")))
        }
    }

    /// This function simulates opening a booster pack for the given set, producing an array of [Card]
    ///
    /// - Parameters:
    ///   - setCode: the set code of the desired set
    ///   - completion: The completion handler (for success / failure response).
    public func generateBoosterForSet(_ setCode: String, completion: @escaping CardCompletion) {
        let urlString = Constants.baseEndpoint + setCode + Constants.generateBoosterPath
        
        guard let url = URL(string: urlString) else {
            return completion(.failure(NetworkError.miscError("generateBooster - build url fail")))
        }
        
        mtgAPIService.mtgAPIQuery(url: url) { result in
            switch result {
            case .success(let json):
                let cards = Parser.parseCards(json: json)
                completion(.success(cards))

            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
