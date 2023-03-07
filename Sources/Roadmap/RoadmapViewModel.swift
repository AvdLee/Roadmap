//
//  RoadmapViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

final class RoadmapViewModel: ObservableObject {
    @Published private(set) var features: [RoadmapFeature] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var allowSearching: Bool
    private let configuration: RoadmapConfiguration

    init(configuration: RoadmapConfiguration) {
        self.configuration = configuration
        self.allowSearching = configuration.allowSearching
        loadFeatures(roadmapJSONURL: configuration.roadmapJSONURL)
    }

    func loadFeatures(roadmapJSONURL: URL) {
        Task { @MainActor in
            isLoading = true
            if configuration.shuffledOrder {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch().shuffled()
            } else {
                self.features = await FeaturesFetcher(featureJSONURL: roadmapJSONURL).fetch()
            }
            isLoading = false
        }
    }

    func featureViewModel(for feature: RoadmapFeature) -> RoadmapFeatureViewModel {
        .init(feature: feature, configuration: configuration)
    }
}
