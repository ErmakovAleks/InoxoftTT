//
//  Constants.swift
//  InoxoftTT
//

import Foundation

enum Constants {

    // MARK: -
    // MARK: Reddit API

    enum RedditAPI {
        static let baseURL = "https://www.reddit.com"
        static let popularPath = "/r/popular.json"
        static let searchPath = "/search.json"
        static let defaultLimit = 25
    }

    // MARK: -
    // MARK: UI

    enum UI {
        static let defaultPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let cornerRadius: CGFloat = 12
        static let thumbnailSize: CGFloat = 70
    }

    // MARK: -
    // MARK: Cache

    enum Cache {
        static let maxCacheAge: TimeInterval = 3600
    }
}
