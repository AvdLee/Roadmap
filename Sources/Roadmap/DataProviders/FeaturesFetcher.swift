//
//  FeaturesFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct FeaturesFetcher {
    let featureRequest: URLRequest

    func fetch() async -> [RoadmapFeature] {
        do {
            return try await JSONDataFetcher.loadJSON(request: featureRequest)
        } catch {
            print("error:", error.localizedDescription)
            return []
        }
    }
}
