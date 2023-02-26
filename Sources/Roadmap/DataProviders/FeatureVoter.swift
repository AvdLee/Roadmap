//
//  FeatureVoter.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct FeatureVoter {
    let feature: RoadmapFeature
    let namespace: String

    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    func vote() async -> Int? {
        guard feature.hasNotFinished else {
            return nil
        }
        
        do {
            let urlString = "https://api.countapi.xyz/hit/\(namespace)/feature\(feature.id)"
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
            feature.hasVoted = true
            print("Successfully voted, count is now: \(count)")
            return count.value
        } catch {
            print("Voting failed: \(error.localizedDescription)")
            return nil
        }
    }
}
