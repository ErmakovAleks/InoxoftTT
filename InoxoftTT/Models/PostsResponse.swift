//
//  PostsResponse.swift
//  InoxoftTT
//

import Foundation

struct PostsResponse: Decodable {

    let kind: String
    let data: PostsData
}

struct PostsData: Decodable {

    let after: String?
    let before: String?
    let children: [PostChild]
}

struct PostChild: Decodable {

    let kind: String
    let data: PostData
}

struct PostData: Decodable {

    let id: String
    let title: String
    let author: String
    let subreddit: String
    let score: Int
    let numComments: Int
    let created: Double
    let thumbnail: String?
    let url: String?
    let selftext: String?
    let permalink: String
    let isVideo: Bool?
    let preview: Preview?

    enum CodingKeys: String, CodingKey {
        case id, title, author, subreddit, score, created
        case thumbnail, url, selftext, permalink, isVideo, preview
        case numComments = "num_comments"
    }

    // MARK: -
    // MARK: Mapping

    func toPost() -> Post {
        let fullSizeURL = self.extractFullSizeURL()

        return Post(
            id: self.id,
            title: self.title,
            author: self.author,
            subreddit: self.subreddit,
            score: self.score,
            numComments: self.numComments,
            created: self.created,
            thumbnailURL: self.extractThumbnailURL(),
            fullSizeURL: fullSizeURL,
            selftext: self.selftext?.isEmpty == true ? nil : self.selftext,
            permalink: "https://www.reddit.com\(self.permalink)",
            isVideo: self.isVideo ?? false
        )
    }

    // MARK: -
    // MARK: Private Methods

    private func extractFullSizeURL() -> String? {
        guard let preview = self.preview,
              let image = preview.images.first,
              let source = image.source
        else {
            return self.url?.hasSuffix(".jpg") == true ||
                   self.url?.hasSuffix(".png") == true ||
                   self.url?.hasSuffix(".gif") == true ? self.url : nil
        }
        return source.url
    }

    private func extractThumbnailURL() -> String? {
        if let thumbnail = self.thumbnail, thumbnail.hasPrefix("http") {
            let unescaped = thumbnail
                .replacingOccurrences(of: "&amp;", with: "&")
                .replacingOccurrences(of: "&lt;", with: "<")
                .replacingOccurrences(of: "&gt;", with: ">")
            return unescaped
        }

        if let resolution = self.preview?.images.first?.resolutions?.first {
            return resolution.url
        }
        return nil
    }
}

// MARK: -
// MARK: Preview Structure

struct Preview: Decodable {

    let images: [PreviewImage]
}

struct PreviewImage: Decodable {

    let source: ImageSource?
    let resolutions: [ImageSource]?
}

struct ImageSource: Decodable {

    let url: String
    let width: Int
    let height: Int

    enum CodingKeys: String, CodingKey {
        case url, width, height
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        var urlString = try container.decode(String.self, forKey: .url)
        urlString = urlString
            .replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")

        self.url = urlString
        self.width = try container.decode(Int.self, forKey: .width)
        self.height = try container.decode(Int.self, forKey: .height)
    }
}
