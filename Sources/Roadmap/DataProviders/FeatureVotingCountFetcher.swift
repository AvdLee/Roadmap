//
//  FeatureVotingCountFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct FeatureVotingCountFetcher {
    let feature: RoadmapFeature
    let namespace: String

    func fetch() async -> Int {
        guard feature.hasNotFinished else {
            return 0
        }
        
        do {
            let urlString = "https://api.countapi.xyz/get/\(namespace)/feature\(feature.id)"
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
            return count.value ?? 0
        } catch {
            print("Fetching voting count failed with error: \(error.localizedDescription)")
            return 0
        }
    }
}
