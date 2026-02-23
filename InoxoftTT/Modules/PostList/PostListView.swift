//
//  PostListView.swift
//  InoxoftTT
//

import SwiftUI
import Kingfisher

struct PostListView: View {

    let viewModel: PostListViewModel
    @State private var searchText = ""
    @State private var showError = false

    // MARK: -
    // MARK: Body

    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
                .ignoresSafeArea()

            if self.viewModel.isLoading && self.viewModel.posts.isEmpty {
                ProgressView(L10n.Common.loading)
            } else if self.viewModel.isEmpty {
                self.emptyStateView
            } else {
                self.postsListView
            }
        }
        .navigationTitle(self.viewModel.isSearchMode ? L10n.PostList.search : L10n.PostList.title)
        .searchable(
            text: self.$searchText,
            placement: .automatic,
            prompt: L10n.PostList.searchPrompt
        )
        .onChange(of: self.searchText) { _, newValue in
            self.viewModel.searchText = newValue
            self.viewModel.onSearchTextChanged()
        }
        .onAppear {
            self.viewModel.viewDidLoaded()
        }
        .onChange(of: self.viewModel.errorMessage) { _, newValue in
            if newValue != nil {
                self.showError = true
            }
        }
        .alert(L10n.Common.error, isPresented: self.$showError) {
            Button(L10n.Common.ok, role: .cancel) {
                self.viewModel.errorMessage = nil
            }
        } message: {
            Text(self.viewModel.errorMessage ?? "")
        }
    }

    // MARK: -
    // MARK: Subviews

    private var postsListView: some View {
        List {
            ForEach(self.viewModel.posts) { post in
                PostRowView(post: post)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if let index = self.viewModel.posts.firstIndex(where: { $0.id == post.id }) {
                            self.viewModel.selectPost(at: index)
                        }
                    }
                    .onAppear {
                        if post.id == self.viewModel.posts.last?.id {
                            self.viewModel.loadMorePosts()
                        }
                    }
            }
        }
        .listStyle(.plain)
        .refreshable {
            self.viewModel.loadPosts()
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: self.viewModel.isSearchMode ? "magnifyingglass" : "newspaper")
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            Text(self.viewModel.isSearchMode ? L10n.PostList.searchForPosts : L10n.PostList.noPostsAvailable)
                .font(.headline)
                .foregroundColor(.secondary)

            if !self.viewModel.isSearchMode {
                Button(L10n.Common.retry) {
                    self.viewModel.loadPosts()
                }
                .buttonStyle(.bordered)
            }
        }
    }
}

// MARK: -
// MARK: Preview

#Preview {
    NavigationView {
        PostListView(viewModel: PostListViewModel(container: DIContainer.self))
    }
}
