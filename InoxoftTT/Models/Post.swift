//
//  Post.swift
//  InoxoftTT
//

import Foundation

struct Post: Identifiable, Hashable {

    let id: String
    let title: String
    let author: String
    let subreddit: String
    let score: Int
    let numComments: Int
    let created: Double
    let thumbnailURL: String?
    let fullSizeURL: String?
    let selftext: String?
    let permalink: String
    let isVideo: Bool

    var createdDate: Date {
        Date(timeIntervalSince1970: self.created)
    }

    var formattedScore: String {
        self.formatNumber(self.score)
    }

    var formattedComments: String {
        "\(self.numComments) \(L10n.PostDetail.comments)"
    }

    // MARK: -
    // MARK: Private Methods

    private func formatNumber(_ value: Int) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", Double(value) / 1_000_000.0)
        } else if value >= 1_000 {
            return String(format: "%.1fK", Double(value) / 1_000.0)
        }
        return "\(value)"
    }
}
