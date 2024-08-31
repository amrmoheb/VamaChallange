//
//  Videos.swift
//  Cronica (iOS)
//
//  Created by Alexandre Madeira on 28/04/22.
//  swiftlint:disable identifier_name

import Foundation
import SwiftUI

struct Videos: Codable, Hashable {
    let results: [VideosResult]
}
struct VideosResult: Codable, Hashable {
    let iso639_1, iso3166_1, id, site: String?
    let name, key, type: String
    let official: Bool
}
/// A model that represents a trailer.
struct VideoItem: Identifiable, Codable, Hashable {
    var id = UUID()
    let url: URL?
    let thumbnail: URL?
    let title: String
    let videoID: String
}
extension VideosResult {
    private var isYouTube: Bool {
        if let site {
            if site.lowercased() == "youtube" { return true }
        }
        return false
    }
    var isTrailer: Bool {
        if official {
            if type.lowercased() == "trailer" {
                return isYouTube
            }
        }
        return false
    }
}
