//
//  PostDetailView.swift
//  InoxoftTT
//

import SwiftUI
import Kingfisher

struct PostDetailView: View {

    let viewModel: PostDetailViewModel
    @State private var showError = false
    @State private var showImageSaved = false

    // MARK: -
    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: Constants.UI.defaultPadding) {
                    Text(self.viewModel.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)

                    HStack {
                        Text(self.viewModel.subreddit)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.orange)

                        Text("•")
                            .foregroundColor(.secondary)

                        Text(self.viewModel.author)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    HStack(alignment: .top, spacing: 16) {
                        HStack(alignment: .top, spacing: 2) {
                            Image(systemName: "arrow.up")
                            Text(self.viewModel.score)
                        }

                        HStack(alignment: .top, spacing: 2) {
                            Image(systemName: "bubble.right")
                            Text(self.viewModel.comments)
                        }

                        HStack(alignment: .top, spacing: 2) {
                            Image(systemName: "clock")
                            Text(self.viewModel.timeAgo)
                        }
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                    Divider()

                    if self.viewModel.hasImage, let imageURL = self.viewModel.imageURL {
                        VStack(alignment: .leading, spacing: 16) {
                            KFImage(imageURL)
                                .placeholder {
                                    ProgressView()
                                        .frame(height: 200)
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .cornerRadius(Constants.UI.cornerRadius)

                            Button(action: {
                                self.viewModel.downloadImage()
                            }) {
                                HStack {
                                    if self.viewModel.isDownloading {
                                        ProgressView()
                                            .tint(.white)
                                    } else {
                                        Image(systemName: "arrow.down.circle")
                                    }
                                    Text(self.viewModel.isDownloading ? L10n.PostDetail.downloading : L10n.PostDetail.saveImage)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(Constants.UI.cornerRadius)
                            }
                            .disabled(self.viewModel.isDownloading)
                        }
                    }

                    if let bodyText = self.viewModel.bodyText, !bodyText.isEmpty {
                        Divider()

                        Text(bodyText)
                            .font(.body)
                            .foregroundColor(.primary)
                    }
                }
                .padding(Constants.UI.defaultPadding)
            }

            Button(action: {
                self.viewModel.openInBrowser()
            }) {
                HStack {
                    Image(systemName: "safari")
                    Text(L10n.PostDetail.openInReddit)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.orange)
                .foregroundColor(.white)
                .cornerRadius(Constants.UI.cornerRadius)
            }
            .padding(Constants.UI.defaultPadding)
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            self.viewModel.onEvent = { event in
                switch event {
                case .imageSaved:
                    self.showImageSaved = true
                case .openInBrowser(let url):
                    UIApplication.shared.open(url)
                }
            }
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
        .alert(L10n.Common.success, isPresented: self.$showImageSaved) {
            Button(L10n.Common.ok, role: .cancel) {}
        } message: {
            Text(L10n.PostDetail.imageSaved)
        }
    }
}

// MARK: -
// MARK: Preview

#Preview {
    let samplePost = Post(
        id: "1",
        title: "Sample Reddit Post Title",
        author: "sampleuser",
        subreddit: "programming",
        score: 15420,
        numComments: 892,
        created: Date().timeIntervalSince1970 - 3600,
        thumbnailURL: nil,
        fullSizeURL: nil,
        selftext: "This is the body text of the Reddit post.",
        permalink: "/r/programming/comments/1",
        isVideo: false
    )

    return NavigationView {
        PostDetailView(viewModel: PostDetailViewModel(post: samplePost, container: DIContainer.self))
    }
}
