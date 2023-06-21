//
//  FeatureVoterCountAPI.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

public struct FeatureVoterCountAPI: FeatureVoter {
    let namespace: String
    
    /// See `https://countapi.xyz/` for more information.
    ///
    /// - Parameter namespace: A unique namespace to use matching your app.
    public init(namespace: String) {
        self.namespace = namespace
    }
    
    /// Fetches the current count for the given feature.
    /// - Returns: The current `count`, else `0` if unsuccessful.
    public func fetch(for feature: RoadmapFeature) async -> Int {
        guard feature.hasNotFinished else {
            return 0
        }
        
        do {
            let urlString = "https://api.countapi.xyz/get/\(namespace)/feature\(feature.id)"
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
            return count.value ?? 0
        } catch {
            print(error)
            print("Fetching voting count failed with error: \(error.localizedDescription)")
            return 0
        }
    }

    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    public func vote(for feature: RoadmapFeature) async -> Int? {
        guard feature.hasNotFinished else {
            return nil
        }
        
        do {
            // we must use hit because we do not know in advance if the namespace exists, and hit will create it for us.
            let urlString = "https://api.countapi.xyz/hit/\(namespace)/feature\(feature.id)"
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
            print("Successfully voted, count is now: \(count)")
            return count.value
        } catch {
            print("Voting failed: \(error.localizedDescription)")
            return nil
        }
    }
    
    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    public func unvote(for feature: RoadmapFeature) async -> Int? {
        guard feature.hasNotFinished else {
            return nil
        }
        
        do {
            // "update" does not create the namespace if it does not exist, therefore we cannot combine vote and unvote into a +1/-1
            let urlString = "https://api.countapi.xyz/update/\(namespace)/feature\(feature.id)?amount=-1"
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)
            print("Successfully unvoted, count is now: \(count)")
            return count.value
        } catch {
            print("Voting failed: \(error.localizedDescription)")
            return nil
        }
    }
}
