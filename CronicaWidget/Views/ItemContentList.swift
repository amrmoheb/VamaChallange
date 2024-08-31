//
//  ItemContentList.swift
//  Cronica (iOS)
//
//  Created by Alexandre Madeira on 26/08/22.
//

import SwiftUI

struct ItemContentList: View {
    let rows: [GridItem] = [
        GridItem(.adaptive(minimum: 60 ))
    ]
    let items: [ItemContent]
    var body: some View {
        VStack {
            if items.isEmpty {
                Text("Trending service ins't available right now.")
                    .font(.callout)
                    .foregroundColor(.secondary)
                    .accessibilityIdentifier("EmptyStateMessage")
            } else {
                list
                .accessibilityIdentifier("ItemContentList")

            }
        }
    }
    private var list: some View {
        ViewThatFits {
            HStack(spacing: .zero) {
                ForEach(items) { item in
                    // Normal size for regular/Pro models.
                    PosterImage(item: item)
                        .frame(width: DrawingConstants.imageWidth,
                               height: DrawingConstants.imageHeight)
                        .shadow(radius: 1)
                        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius, style: .continuous))
                        .padding(.leading, item.id == items.first?.id ? 0 : 6)
                        .accessibilityIdentifier("PosterImage")

                }
            }
            HStack {
                ForEach(items) { item in
                    // Small size for SE
                    PosterImage(item: item)
                        .frame(width: DrawingConstants.smallImageWidth,
                               height: DrawingConstants.smallImageHeight)
                        .clipShape(RoundedRectangle(cornerRadius: DrawingConstants.imageRadius, style: .continuous))
                        .padding(.leading, item.id == items.first?.id ? 0 : 4)
                        .accessibilityIdentifier("PosterImage")

                }
            }
        }
    }
}

private struct PosterImage: View {
    let item: ItemContent
    @State private var showPlaceholder = false
    var body: some View {
        Link(destination: URL(string: item.itemContentID)!) {
            if let placeholder = item.placeholderImagePath {
                Image(placeholder)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else if let image = item.data {
#if os(iOS)
                Image(uiImage: UIImage(data: image) ?? UIImage(systemName: "popcorn.fill")!)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
#elseif os(macOS)
                if let nsImage = NSImage(data: image) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else {
                    Image(systemName: "popcorn.fill")
                }
#endif
            } else {
                PlaceholderImage()
            }
        }
        .task {
            if item.data == nil {
                showPlaceholder = true
            }
        }
    }
}

private struct PlaceholderImage: View {
    var body: some View {
        VStack {
            ZStack {
                Rectangle().fill(Color.gray.gradient)
                Image(systemName: "popcorn.fill")
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

private struct DrawingConstants {
    static let imageWidth: CGFloat = 74
    static let imageHeight: CGFloat = 130
    static let smallImageWidth: CGFloat = 68
    static let smallImageHeight: CGFloat = 110
    static let imageRadius: CGFloat = 6
}
