//
//  PostCellModel.swift
//  InoxoftTT
//

import Foundation

struct PostCellModel: Identifiable, Hashable {

    let id: String
    let title: String
    let author: String
    let subreddit: String
    let scoreText: String
    let commentsText: String
    let timeAgo: String
    let thumbnailURL: URL?
    let hasImage: Bool
    let hasText: Bool

    // MARK: -
    // MARK: Initialization

    init(from post: Post) {
        self.id = post.id
        self.title = post.title
        self.author = "u/\(post.author)"
        self.subreddit = "r/\(post.subreddit)"
        self.scoreText = post.formattedScore
        self.commentsText = post.formattedComments
        self.timeAgo = Self.formatTimeAgo(from: post.createdDate)
        self.thumbnailURL = post.thumbnailURL.flatMap { URL(string: $0) }
        self.hasImage = post.fullSizeURL != nil
        self.hasText = post.selftext != nil && !post.selftext!.isEmpty
    }

    // MARK: -
    // MARK: Private Methods

    private static func formatTimeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
