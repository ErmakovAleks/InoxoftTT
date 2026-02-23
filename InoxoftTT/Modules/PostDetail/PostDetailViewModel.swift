//
//  PostDetailViewModel.swift
//  InoxoftTT
//

import Foundation
import Observation
import UIKit
import Photos

enum PostDetailOutputEvent {
    case imageSaved
    case openInBrowser(URL)
}

@MainActor
@Observable
final class PostDetailViewModel {

    private let post: Post
    private let container: ServiceContainable.Type

    let title: String
    let author: String
    let subreddit: String
    let score: String
    let comments: String
    let timeAgo: String
    let bodyText: String?
    let imageURL: URL?
    let hasImage: Bool
    let permalink: URL?

    var isDownloading = false
    var errorMessage: String?

    var onEvent: ((PostDetailOutputEvent) -> Void)?

    // MARK: -
    // MARK: Initialization

    init(post: Post, container: ServiceContainable.Type) {
        self.post = post
        self.container = container

        self.title = post.title
        self.author = "u/\(post.author)"
        self.subreddit = "r/\(post.subreddit)"
        self.score = post.formattedScore
        self.comments = post.formattedComments
        self.timeAgo = Self.formatTimeAgo(from: post.createdDate)
        self.bodyText = post.selftext
        self.imageURL = post.fullSizeURL.flatMap { URL(string: $0) }
        self.hasImage = self.imageURL != nil
        self.permalink = URL(string: post.permalink)
    }

    // MARK: -
    // MARK: Public Methods

    func downloadImage() {
        guard let url = self.imageURL else { return }

        self.isDownloading = true

        Task {
            do {
                let image = try await self.container.imageLoader.downloadImage(from: url)
                self.saveToPhotoLibrary(image)
            } catch {
                self.errorMessage = L10n.Error.failedDownloadImage(error.localizedDescription)
            }
            self.isDownloading = false
        }
    }

    func openInBrowser() {
        guard let url = self.permalink else { return }
        self.onEvent?(.openInBrowser(url))
    }

    // MARK: -
    // MARK: Private Methods

    private func saveToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.shared().performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { success, error in
            Task { @MainActor in
                if let error {
                    self.errorMessage = L10n.Error.failedSaveImage(error.localizedDescription)
                    return
                }
                if success {
                    self.onEvent?(.imageSaved)
                }
            }
        }
    }

    private static func formatTimeAgo(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
