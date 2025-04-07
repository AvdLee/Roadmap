//
//  FeatureVoterSidetrack.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

public struct FeatureVoterSidetrack: FeatureVoter {
    public init() {}
    
    /// Fetches the current count for the given feature.
    /// - Returns: The current `count`, else `0` if unsuccessful.
    public func fetch(for feature: RoadmapFeature) async -> Int {
        guard feature.hasNotFinished else {
            return 0
        }
        
        do {
            let urlString = "https://roadmap.sidetrack.app/item/\(feature.id)"
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
            guard let url = URL(string: "https://roadmap.sidetrack.app/item/\(feature.id)/vote") else {
                throw JSONDataFetcher.Error.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(request: request)
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
            guard let url = URL(string: "https://roadmap.sidetrack.app/item/\(feature.id)/unvote") else {
                throw JSONDataFetcher.Error.invalidURL
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(request: request)
            print("Successfully unvoted, count is now: \(count)")
            return count.value
        } catch {
            print("Voting failed: \(error.localizedDescription)")
            return nil
        }
    }
}
