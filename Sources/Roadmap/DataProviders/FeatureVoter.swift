//
//  FeatureVoter.swift
//  Roadmap
//
//  Created by James Sherlock on 23/02/2023.
//

import Foundation

public protocol FeatureVoter: Sendable {
    /// Fetches the current count for the given feature.
    func fetch(for feature: RoadmapFeature) async -> Int

    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    func vote(for feature: RoadmapFeature) async -> Int?

    /// Removes a vote for the given feature.
    /// - Returns: The new `count` if successful.
    func unvote(for feature: RoadmapFeature) async -> Int?
}
