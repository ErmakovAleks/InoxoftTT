//
//  L10n.swift
//  InoxoftTT
//

import Foundation

enum L10n {

    // MARK: - Common

    enum Common {
        static let ok = "ok".localized
        static let error = "error".localized
        static let success = "success".localized
        static let loading = "loading".localized
        static let retry = "retry".localized
    }

    // MARK: - Post List

    enum PostList {
        static let title = "reddit_popular".localized
        static let search = "search".localized
        static let searchPrompt = "search_posts".localized
        static let searchForPosts = "search_for_posts".localized
        static let noPostsAvailable = "no_posts_available".localized
    }

    // MARK: - Post Detail

    enum PostDetail {
        static let title = "post_details".localized
        static let saveImage = "save_image".localized
        static let downloading = "downloading".localized
        static let openInReddit = "open_in_reddit".localized
        static let imageSaved = "image_saved".localized
        static let comments = "comments".localized
    }

    // MARK: - Placeholder

    enum Placeholder {
        static let selectPost = "select_a_post".localized
        static let choosePostDetails = "choose_post_details".localized
    }

    // MARK: - Content Badges

    enum Badge {
        static let image = "image".localized
        static let text = "text".localized
    }

    // MARK: - Errors

    enum Error {
        static func failedDownloadImage(_ error: String) -> String {
            "failed_download_image".localized(with: error)
        }

        static func failedSaveImage(_ error: String) -> String {
            "failed_save_image".localized(with: error)
        }
    }
}
