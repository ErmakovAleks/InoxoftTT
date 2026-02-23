//
//  CachedPost.swift
//  InoxoftTT
//

import Foundation
import RealmSwift

final class CachedPost: Object {

    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var author: String
    @Persisted var subreddit: String
    @Persisted var score: Int
    @Persisted var numComments: Int
    @Persisted var created: Double
    @Persisted var thumbnailURL: String?
    @Persisted var fullSizeURL: String?
    @Persisted var selftext: String?
    @Persisted var permalink: String
    @Persisted var isVideo: Bool
    @Persisted var cachedAt: Date

    // MARK: -
    // MARK: Initialization

    convenience init(
        id: String,
        title: String,
        author: String,
        subreddit: String,
        score: Int,
        numComments: Int,
        created: Double,
        thumbnailURL: String?,
        fullSizeURL: String?,
        selftext: String?,
        permalink: String,
        isVideo: Bool
    ) {
        self.init()
        self.id = id
        self.title = title
        self.author = author
        self.subreddit = subreddit
        self.score = score
        self.numComments = numComments
        self.created = created
        self.thumbnailURL = thumbnailURL
        self.fullSizeURL = fullSizeURL
        self.selftext = selftext
        self.permalink = permalink
        self.isVideo = isVideo
        self.cachedAt = Date()
    }

    // MARK: -
    // MARK: Mapping

    convenience init(from post: Post) {
        self.init(
            id: post.id,
            title: post.title,
            author: post.author,
            subreddit: post.subreddit,
            score: post.score,
            numComments: post.numComments,
            created: post.created,
            thumbnailURL: post.thumbnailURL,
            fullSizeURL: post.fullSizeURL,
            selftext: post.selftext,
            permalink: post.permalink,
            isVideo: post.isVideo
        )
    }

    func toPost() -> Post {
        Post(
            id: self.id,
            title: self.title,
            author: self.author,
            subreddit: self.subreddit,
            score: self.score,
            numComments: self.numComments,
            created: self.created,
            thumbnailURL: self.thumbnailURL,
            fullSizeURL: self.fullSizeURL,
            selftext: self.selftext,
            permalink: self.permalink,
            isVideo: self.isVideo
        )
    }
}
