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
        Task {
            do {
                let urlString = "https://simplejsoncms.com/api/vq2juq1xhg"
                let features: [RoadmapFeature] = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
                await MainActor.run {
                    self.features = features
                }
            } catch {
                print("error:", error.localizedDescription)
            }
        }
    }

}
