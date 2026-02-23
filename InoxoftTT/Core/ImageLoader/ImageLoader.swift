//
//  ImageLoader.swift
//  InoxoftTT
//

import Foundation
import UIKit
import Kingfisher

protocol ImageLoaderProtocol {

    func loadImage(
        from url: URL,
        into imageView: UIImageView,
        placeholder: UIImage?,
        completion: ((Result<UIImage, Error>) -> Void)?
    )

    func downloadImage(from url: URL) async throws -> UIImage

    func clearCache()
}

final class ImageLoader: ImageLoaderProtocol {

    static let shared = ImageLoader()

    // MARK: -
    // MARK: Initialization

    private init() {}

    // MARK: -
    // MARK: ImageLoaderProtocol

    func loadImage(
        from url: URL,
        into imageView: UIImageView,
        placeholder: UIImage? = nil,
        completion: ((Result<UIImage, Error>) -> Void)? = nil
    ) {
        imageView.kf.setImage(
            with: url,
            placeholder: placeholder,
            options: [
                .transition(.fade(0.3)),
                .cacheOriginalImage
            ]
        ) { result in
            switch result {
            case .success(let imageResult):
                completion?(.success(imageResult.image))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func downloadImage(from url: URL) async throws -> UIImage {
        try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(
                with: url,
                options: [
                    .cacheOriginalImage
                ]
            ) { result in
                switch result {
                case .success(let imageResult):
                    continuation.resume(returning: imageResult.image)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}
