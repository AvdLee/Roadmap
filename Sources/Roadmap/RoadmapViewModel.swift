//
//  RoadmapViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

@MainActor
@Observable
final class RoadmapViewModel {
    static let allStatusFilter: String = "all"

    private var features: [RoadmapFeature] = []
    var searchText = ""
    var statusToFilter = RoadmapViewModel.allStatusFilter

    var filteredFeatures: [RoadmapFeature] {
        features.filter { feature in
            let matchesStatus = statusToFilter == "all" || feature.localizedFeatureStatus == statusToFilter
            let matchesSearch =
                searchText.isEmpty ||
                feature.localizedFeatureTitle.lowercased().contains(searchText.lowercased()) ||
                feature.localizedFeatureDescription.lowercased().contains(searchText.lowercased())
            
            return matchesStatus && matchesSearch
        }
    }
    
    let allowSearching: Bool
    let allowsFilterByStatus: Bool
    var statuses: [String] = []

    private let configuration: RoadmapConfiguration
    
    init(configuration: RoadmapConfiguration) {
        self.configuration = configuration
        self.allowSearching = configuration.allowSearching
        self.allowsFilterByStatus = configuration.allowsFilterByStatus
        loadFeatures(request: configuration.roadmapRequest)
    }

    func loadFeatures(request: URLRequest) {
        
        Task { @MainActor in
            if configuration.shuffledOrder {
                self.features = await FeaturesFetcher(featureRequest: request).fetch().shuffled()
            } else if let sorting = configuration.sorting {
                self.features = await FeaturesFetcher(featureRequest: request).fetch().sorted(by: sorting)
            } else {
                self.features = await FeaturesFetcher(featureRequest: request).fetch()
            }
            
            self.statuses = {
                var featureStatuses = [RoadmapViewModel.allStatusFilter]
                featureStatuses.append(contentsOf: Array(Set(self.features.map { $0.localizedFeatureStatus ?? "" })))
                return featureStatuses
            }()
        }
    }
    
    func filterFeatures(by status: String) {
        self.statusToFilter = status
    }

    func featureViewModel(for feature: RoadmapFeature) -> RoadmapFeatureViewModel {
        .init(feature: feature, configuration: configuration)
    }
}
