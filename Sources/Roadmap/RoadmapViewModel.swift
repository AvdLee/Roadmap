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
    @Published var statusToFilter = "all"

    var filteredFeatures: [RoadmapFeature] {
        if statusToFilter == "all" && searchText.isEmpty {
            return features
        } else if statusToFilter != "all" && searchText.isEmpty {
            if searchText.isEmpty {
                return features.filter { feature in
                    feature.featureStatus == statusToFilter
                }
            } else {
                return features.filter { feature in
                    feature
                        .localizedFeatureTitle
                        .lowercased()
                        .contains(searchText.lowercased())
                    &&
                    feature.featureStatus == statusToFilter
                }
            }
        } else {
            return features.filter { feature in
                feature
                    .localizedFeatureTitle
                    .lowercased()
                    .contains(searchText.lowercased())
            }
        }
    }
    
    let allowSearching: Bool
    var statuses: [String] = []

    private let configuration: RoadmapConfiguration
    
    init(configuration: RoadmapConfiguration) {
        self.configuration = configuration
        self.allowSearching = configuration.allowSearching
        loadFeatures(roadmapJSONURL: configuration.roadmapJSONURL)
    }

    func loadFeatures(roadmapJSONURL: URL) {
        Task { @MainActor in
            if configuration.shuffledOrder {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch().shuffled()
            } else {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch()
            }
            
            self.statuses = {
                var featureStatuses = ["all"]
                featureStatuses.append(contentsOf: Array(Set(self.features.map { $0.featureStatus ?? "" })))
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
