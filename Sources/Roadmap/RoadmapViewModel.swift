//
//  RoadmapViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

final class RoadmapViewModel: ObservableObject {
    @Published private var features: [RoadmapFeature] = []
    @Published var searchText = ""
    private var allFeatures: [RoadmapFeature] = []

    var filteredFeatures: [RoadmapFeature] {
        guard !searchText.isEmpty else {
            return features
        }
        return features.filter { feature in
            feature
                .featureTitle
                .lowercased()
                .contains(searchText.lowercased())
        }
    }
    let allowSearching: Bool

    private let configuration: RoadmapConfiguration
    var statuses: [String] = []
    
    init(configuration: RoadmapConfiguration) {
        self.configuration = configuration
        self.allowSearching = configuration.allowSearching
        loadFeatures(roadmapJSONURL: configuration.roadmapJSONURL)
    }

    func loadFeatures(roadmapJSONURL: URL) {
        Task { @MainActor in
            if configuration.shuffledOrder {
                self.allFeatures = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch().shuffled()
            } else {
                self.allFeatures = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch()
            }
            self.statuses = {
                var featureStatuses = ["all"]
                featureStatuses.append(contentsOf: Array(Set(self.allFeatures.map { $0.featureStatus ?? "" })))
                return featureStatuses
            }()
            self.features = self.allFeatures
        }
    }
    
    func filterFeatures(by status: String) {
        if status == "all" {
            self.features = self.allFeatures
        } else {
            self.features = self.allFeatures.filter { $0.featureStatus! == status }
        }
    }

    func featureViewModel(for feature: RoadmapFeature) -> RoadmapFeatureViewModel {
        .init(feature: feature, configuration: configuration)
    }
}
