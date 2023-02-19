//
//  FeaturesFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct FeaturesFetcher {
    let featureJSONURL: URL

    func fetch() async -> [RoadmapFeature] {
        do {
            return try await JSONDataFetcher.loadJSON(url: featureJSONURL)
        } catch {
            print("error:", error.localizedDescription)
            return []
        }
    }
}
