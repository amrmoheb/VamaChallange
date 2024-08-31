//
//  HomeViewModel.swift
//  Cronica
//
//  Created by Alexandre Madeira on 02/03/22.
//

import CoreData
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    private let service: NetworkService = NetworkService.shared
    @Published var trending = [ItemContent]()
    @Published var sections = [ItemContentSection]()
    @Published var isLoaded = false
   
    
    // new feature test
    @Published var nextYearMovies: [[ItemContent]:YearEndpoint]?
    @Published var yearMovies = [ItemContent]()
    
    func fetchYearMovies() async {
        let year = try? await service.fetchYearContent(year: "2024", type: .movie)
        guard let year else { return }
        yearMovies.append(contentsOf: year)
    }
    
    /// Loads data for the home screen asynchronously, including trending items, sections, and recommendations.
    func load() async {
        if trending.isEmpty {
            do {
                let result = try await service.fetchItems(from: "trending/all/day")
                let filtered = result.filter { $0.itemContentMedia != .person }
                trending = filtered
            } catch {
                if Task.isCancelled { return }
            }
        }
        if sections.isEmpty {
            let result = await self.fetchSections()
            sections.append(contentsOf: result)
        }
        await MainActor.run {
            withAnimation { self.isLoaded = true }
        }
        
        if yearMovies.isEmpty {
            await fetchYearMovies()
        }
    }
    
    func reload() {
        withAnimation {
            isLoaded = false
            //isLoadingRecommendations = true
        }
        trending.removeAll()
        sections.removeAll()
       // recommendations.removeAll()
        Task { await load() }
    }
    
    private func fetchSections() async -> [ItemContentSection] {
        let endpoints = Endpoints.allCases
        var sections = [ItemContentSection]()
        for endpoint in endpoints {
            let section = await fetch(from: endpoint)
            if let section {
                sections.append(section)
            }
        }
        return sections
    }
    
    /// Fetch an Endpoint value.
    /// - Parameter endpoint: The endpoint used for popular, upcoming, etc.
    /// - Returns: Return a ItemContentSection already populated with Endpoint value if that fetch is successful, otherwise it returns nil.
    private func fetch(from endpoint: Endpoints) async -> ItemContentSection? {
        do {
            let section = try await service.fetchItems(from: "\(endpoint.type.rawValue)/\(endpoint.rawValue)")
            let filtered = section.filter { $0.backdropPath != nil && $0.posterPath != nil }
            return .init(results: filtered, endpoint: endpoint)
        } catch {
            if Task.isCancelled { return nil }
            return nil
        }
    }
    
    
}

/// Theses keywords are used in some NSFW titles, this should be only used
/// for avoiding displaying such titles in recommendations lists, explore and search.
let nsfwKeywords = [155477, 230416, 190370, 158254, 159551, 301766]


struct YearEndpoint: Identifiable, Hashable, Codable {
    let id: UUID
    let year: String
}
