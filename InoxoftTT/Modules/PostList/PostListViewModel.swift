//
//  PostListViewModel.swift
//  InoxoftTT
//

import Foundation
import Observation

enum PostListOutputEvent {
    case showPostDetail(Post)
}

@MainActor
@Observable
final class PostListViewModel {

    private let container: ServiceContainable.Type
    let isSearchMode: Bool

    var searchText = ""
    var posts: [PostCellModel] = []
    var isEmpty = false
    var isLoading = false
    var errorMessage: String?

    private var currentAfter: String?
    private var isLoadingMore = false
    private var hasMorePages = true
    private var isLoaded = false
    private var lastSearchTimestamp = Date()

    var onEvent: ((PostListOutputEvent) -> Void)?

    // MARK: -
    // MARK: Initialization

    init(container: ServiceContainable.Type, isSearchMode: Bool = false) {
        self.container = container
        self.isSearchMode = isSearchMode
    }

    // MARK: -
    // MARK: Lifecycle

    func viewDidLoaded() {
        guard !self.isLoaded else { return }
        self.isLoaded = true

        if !self.isSearchMode {
            self.loadPosts()
        }
    }

    func onSearchTextChanged() {
        let timestamp = Date()
        self.lastSearchTimestamp = timestamp

        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)

            guard timestamp == self.lastSearchTimestamp else { return }
            self.search(query: self.searchText)
        }
    }

    // MARK: -
    // MARK: Public Methods

    func loadPosts() {
        guard !self.isLoading else { return }

        self.isLoading = true
        self.currentAfter = nil
        self.hasMorePages = true

        let cachedPosts = self.container.persistenceService.loadPosts()
        if !cachedPosts.isEmpty {
            let cellModels = cachedPosts.map { PostCellModel(from: $0) }
            self.posts = cellModels
            self.isEmpty = cellModels.isEmpty
        }

        Task {
            do {
                let posts = try await self.fetchPosts(request: PopularPostsRequest())
                self.handlePostsResult(.success(posts), isLoadMore: false)
            } catch {
                self.handlePostsResult(.failure(error as? RequestError ?? .unknown(error.localizedDescription)), isLoadMore: false)
            }
        }
    }

    func loadMorePosts() {
        guard !self.isLoadingMore, self.hasMorePages, !self.isLoading else { return }

        self.isLoadingMore = true

        Task {
            do {
                let posts = try await self.fetchPosts(request: PopularPostsRequest(after: self.currentAfter))
                self.handlePostsResult(.success(posts), isLoadMore: true)
            } catch {
                self.handlePostsResult(.failure(error as? RequestError ?? .unknown(error.localizedDescription)), isLoadMore: true)
            }
        }
    }

    func search(query: String) {
        guard !query.isEmpty else {
            self.loadPosts()
            return
        }

        self.isLoading = true
        self.currentAfter = nil
        self.hasMorePages = true

        let cachedResults = self.container.persistenceService.loadPosts(matching: query)
        if !cachedResults.isEmpty {
            let cellModels = cachedResults.map { PostCellModel(from: $0) }
            self.posts = cellModels
            self.isEmpty = cellModels.isEmpty
        }

        Task {
            do {
                let posts = try await self.fetchPosts(request: SearchPostsRequest(query: query))
                self.handlePostsResult(.success(posts), isLoadMore: false)
            } catch {
                self.handlePostsResult(.failure(error as? RequestError ?? .unknown(error.localizedDescription)), isLoadMore: false)
            }
        }
    }

    func selectPost(at index: Int) {
        guard index < self.posts.count else { return }

        let cellModel = self.posts[index]
        if let cachedPost = self.container.persistenceService.loadPosts().first(where: { $0.id == cellModel.id }) {
            self.onEvent?(.showPostDetail(cachedPost))
        }
    }

    // MARK: -
    // MARK: Private Methods

    private func fetchPosts<T: URLContainable>(request: T) async throws -> [Post] where T.DecodableType == PostsResponse {
        let response = try await self.container.networkService.sendRequest(requestModel: request)
        let posts = response.data.children.map { $0.data.toPost() }

        self.container.persistenceService.savePosts(posts)

        self.currentAfter = response.data.after
        self.hasMorePages = response.data.after != nil

        return posts
    }

    private func handlePostsResult(_ result: Result<[Post], RequestError>, isLoadMore: Bool) {
        self.isLoading = false
        self.isLoadingMore = false

        switch result {
        case .success(let newPosts):
            let newCellModels = newPosts.map { PostCellModel(from: $0) }

            if isLoadMore {
                self.posts += newCellModels
                self.isEmpty = self.posts.isEmpty
            } else {
                let currentIds = Set(self.posts.map(\.id))
                let newIds = Set(newCellModels.map(\.id))

                if currentIds != newIds {
                    self.posts = newCellModels
                    self.isEmpty = self.posts.isEmpty
                }
            }

        case .failure(let error):
            if self.posts.isEmpty {
                self.errorMessage = error.errorDescription ?? "Unknown error"
                self.isEmpty = true
            }
        }
    }
}
