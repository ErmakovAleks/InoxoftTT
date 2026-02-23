//
//  PlaceholderDetailView.swift
//  InoxoftTT
//

import SwiftUI

struct PlaceholderDetailView: View {

    // MARK: -
    // MARK: Body

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "newspaper.fill")
                .font(.system(size: 80))
                .foregroundColor(.secondary)

            Text(L10n.Placeholder.selectPost)
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.secondary)

            Text(L10n.Placeholder.choosePostDetails)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: -
// MARK: Preview

#Preview {
    PlaceholderDetailView()
}
