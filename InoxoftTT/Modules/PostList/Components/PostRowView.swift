//
//  PostRowView.swift
//  InoxoftTT
//

import SwiftUI
import Kingfisher

struct PostRowView: View {

    let post: PostCellModel

    // MARK: -
    // MARK: Body

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let thumbnailURL = self.post.thumbnailURL {
                KFImage(thumbnailURL)
                    .placeholder {
                        self.thumbnailPlaceholder
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: Constants.UI.thumbnailSize, height: Constants.UI.thumbnailSize)
                    .clipShape(RoundedRectangle(cornerRadius: Constants.UI.smallPadding))
            } else {
                self.thumbnailPlaceholder
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(self.post.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(2)
                    .foregroundColor(.primary)

                HStack(alignment: .top, spacing: 4) {
                    Text(self.post.subreddit)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)

                    Text("|")
                        .font(.caption)
                        .foregroundColor(.secondary)

                    Text(self.post.author)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .truncationMode(.tail)
                }

                HStack(alignment: .top, spacing: 12) {
                    HStack(alignment: .top, spacing: 2) {
                        Image(systemName: "arrow.up")
                        Text(self.post.scoreText)
                    }

                    HStack(alignment: .top, spacing: 2) {
                        Image(systemName: "bubble.right")
                        Text(self.post.commentsText)
                    }

                    Text(self.post.timeAgo)
                }
                .font(.caption2)
                .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    if self.post.hasImage {
                        self.contentBadge(icon: "photo", text: L10n.Badge.image)
                    }

                    if self.post.hasText {
                        self.contentBadge(icon: "text.alignleft", text: L10n.Badge.text)
                    }
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.body)
                .foregroundColor(.secondary)
                .offset(y: 8)
        }
        .contentShape(Rectangle())
    }

    // MARK: -
    // MARK: Subviews

    private var thumbnailPlaceholder: some View {
        Rectangle()
            .fill(Color(uiColor: .secondarySystemBackground))
            .frame(width: Constants.UI.thumbnailSize, height: Constants.UI.thumbnailSize)
            .clipShape(RoundedRectangle(cornerRadius: Constants.UI.smallPadding))
            .overlay(
                Image(systemName: "photo")
                    .foregroundColor(.secondary)
            )
    }

    private func contentBadge(icon: String, text: String) -> some View {
        HStack(spacing: 2) {
            Image(systemName: icon)
                .font(.caption2)
            
            Text(text)
                .font(.caption2)
        }
        .foregroundColor(.secondary)
        .padding(.horizontal, 6)
        .padding(.vertical, 2)
        .background(Color(uiColor: .secondarySystemBackground))
        .clipShape(Capsule())
    }
}

// MARK: -
// MARK: Preview

#Preview {
    let samplePost = PostCellModel(from: Post(
        id: "1",
        title: "This is a sample Reddit post title that might be quite long",
        author: "sampleuser",
        subreddit: "programming",
        score: 15420,
        numComments: 892,
        created: Date().timeIntervalSince1970 - 3600,
        thumbnailURL: nil,
        fullSizeURL: nil,
        selftext: "Sample text",
        permalink: "/r/programming/comments/1",
        isVideo: false
    ))

    return PostRowView(post: samplePost)
        .padding()
}
