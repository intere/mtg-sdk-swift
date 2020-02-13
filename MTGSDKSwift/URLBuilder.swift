//
//  URLBuilder.swift
//  MTGSDKSwift
//
//  Created by Reed Carson on 4/5/18.
//  Copyright © 2018 Reed Carson. All rights reserved.
//

import Foundation

final class URLBuilder {

    static func buildCardSearchUrl(parameters: [CardSearchParameter], andConfig config: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration) -> URL? {
        return buildURLWithParameters(parameters, path: Constants.cardsEndpoint, andConfig: config)
    }

    static func buildSetSearchUrl(parameters: [SetSearchParameter], andConfig config: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration) -> URL? {
        return buildURLWithParameters(parameters, path: Constants.setsEndpoint, andConfig: config)
    }

}

// MARK: - Implementation

private extension URLBuilder {

    static func buildURLWithParameters(_ parameters: [SearchParameter],
                                       path: String,
                                       andConfig config: MTGSearchConfiguration) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = Constants.scheme
        urlComponents.host = Constants.host
        urlComponents.path = path
        urlComponents.queryItems = buildQueryItemsFromParameters(parameters, config)

        if let url = urlComponents.url {
            debugPrint("MTGSDK URL: \(String(describing: url))\n")
        }
        
        return urlComponents.url
    }
    
    static func buildQueryItemsFromParameters(_ parameters: [SearchParameter],
                                               _ config: MTGSearchConfiguration = MTGSearchConfiguration.defaultConfiguration) -> [URLQueryItem] {
        var queryItems = [URLQueryItem]()
        
        let pageSizeQuery = URLQueryItem(name: "pageSize", value: String(config.pageSize))
        let pageQuery = URLQueryItem(name: "page", value: String(config.pageTotal))
        queryItems.append(pageQuery)
        queryItems.append(pageSizeQuery)
        
        for parameter in parameters {
            let name = parameter.name
            let value = parameter.value
            let item = URLQueryItem(name: name, value: value)
            queryItems.append(item)
        }
        
        return queryItems
    }
}
