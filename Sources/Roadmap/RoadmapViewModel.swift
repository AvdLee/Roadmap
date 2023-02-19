//
//  RoadmapViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

final class RoadmapViewModel: ObservableObject {
    @Published private(set) var features: [RoadmapFeature] = []

    init() {
        loadFeatures()
    }

    func loadFeatures() {
        Task { @MainActor in
            let urlString = "https://simplejsoncms.com/api/vq2juq1xhg"
            self.features = await FeaturesFetcher(featureJSONURLString: urlString).fetch()
        }
    }
}
