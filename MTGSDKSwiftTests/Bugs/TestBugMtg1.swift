//
//  TestBugMtg1.swift
//  MTGSDKSwiftTests
//
//  Created by Eric Internicola on 2/13/20.
//  Copyright © 2020 Reed Carson. All rights reserved.
//

@testable import MTGSDKSwift
import XCTest

class TestBugMtg1: XCTestCase {

    func testBrokenUrl() {
        guard let url = URLBuilder.buildSetSearchUrl(parameters: []) else {
            return XCTFail("No URL")
        }
        XCTAssertEqual("/v1/sets", url.path)
    }

    func testBrokenFetch() {
        let config = MTGSearchConfiguration(pageSize: 1, pageTotal: 1)

        let exp = expectation(description: "Fetch Sets")
        Magic().fetchSets([], configuration: config) { result in
            switch result {
            case .failure(let error):
                XCTFail("error: \(error.localizedDescription)")
            case .success(let cards):
                XCTAssertEqual(config.pageSize, cards.count)
            }
            exp.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

}
