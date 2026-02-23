//
//  RedditRequests.swift
//  InoxoftTT
//

import Foundation

struct PopularPostsRequest: URLContainable {

    typealias DecodableType = PostsResponse

    var path: String { "/r/popular.json" }
    var queryItems: [URLQueryItem]?

    // MARK: -
    // MARK: Initialization

    init(limit: Int = 25, after: String? = nil) {
        var items = [URLQueryItem(name: "limit", value: "\(limit)")]

        if let after = after {
            items.append(URLQueryItem(name: "after", value: after))
        }

        self.queryItems = items
    }
}

struct SearchPostsRequest: URLContainable {

    typealias DecodableType = PostsResponse

    var path: String { "/search.json" }
    var queryItems: [URLQueryItem]?

    // MARK: -
    // MARK: Initialization

    init(query: String, limit: Int = 25, after: String? = nil) {
        var items = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "limit", value: "\(limit)"),
            URLQueryItem(name: "type", value: "link")
        ]

        if let after = after {
            items.append(URLQueryItem(name: "after", value: after))
        }

        self.queryItems = items
    }
}
