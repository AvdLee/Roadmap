//
//  RoadmapConfiguration.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation
import SwiftUI

public struct RoadmapConfiguration: Sendable {
    /// Instead of a simple URL a Request is also possible for a more advanced way to the JSON
    public let roadmapRequest: URLRequest
    
    /// The interface for retrieving and saving votes.
    public let voter: FeatureVoter

    /// The interface for retrieving features
    public let fetcher: FeaturesFetcher

    /// Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    public let style: RoadmapStyle
    
    /// Set this to true to have a different order of features everytime the view is presented
    public let shuffledOrder: Bool
    
    /// Set this to true to if you want to let users vote. Set it to false for read-only mode. This can be used to only let paying users vote for example.
    public let allowVotes: Bool
    
    /// Set this to true to if you want to add a search bar so users can filter which features are shown.
    public let allowSearching: Bool
    
    /// Set this to true to if you want to allow users to filter features by any one status from a dynamically populated list of statuses.
    public let allowsFilterByStatus: Bool

    /// If set, will be used for sorting features.
    public let sorting: (@Sendable (RoadmapFeature, RoadmapFeature) -> Bool)?

    /// Creates a new Roadmap configuration instance.
    /// - Parameters:
    ///   - roadmapJSONURL: The URL pointing to the JSON in the `RoadmapFeature` format.
    ///   - roadmapRequest: The Request pointing to the JSON in the `RoadmapFeature` format.
    ///   - voter: The interface to use for retrieving and persisting votes.
    ///   - style: Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    ///   - shuffledOrder: Set this to true to have a different order of features everytime the view is presented
    ///   - sorting: If set, will be used for sorting features.
    ///   - allowVotes: Set this to true to if you want to let users vote. Set it to false for read-only mode. This can be used to only let paying users vote for example.
    ///   - allowSearching: Set this to true to if you want to add a search bar so users can filter which features are shown.
    public init(roadmapJSONURL: URL? = nil,
                roadmapRequest: URLRequest? = nil,
                voter: FeatureVoter,
                style: RoadmapStyle = RoadmapTemplate.standard.style,
                shuffledOrder: Bool = false,
                sorting: (@Sendable (RoadmapFeature, RoadmapFeature) -> Bool)? = nil,
                allowVotes: Bool = true,
                allowSearching: Bool = false,
                allowsFilterByStatus: Bool = false) {
        
        guard roadmapJSONURL != nil || roadmapRequest != nil else {
            fatalError("Missing roadmap URL or request")
        }
        
        guard let url = roadmapJSONURL ?? roadmapRequest?.url else {
            fatalError("Missing URL")
        }

        let roadmapRequest = roadmapRequest ?? URLRequest(url: url)

        self.init(
            roadmapRequest: roadmapRequest,
            voter: voter,
            fetcher: FeaturesFetcherJSON(featureRequest: roadmapRequest),
            style: style,
            shuffledOrder: shuffledOrder,
            sorting: sorting,
            allowVotes: allowVotes,
            allowSearching: allowSearching,
            allowsFilterByStatus: allowsFilterByStatus
        )
    }
    
    /// Creates a new Roadmap configuration instance.
    /// - Parameters:
    ///   - sidetrackRoadmapId: The ID from the Sidetrack (https://roadmap.sidetrack.app) roadmap service.
    ///   - style: Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    ///   - shuffledOrder: Set this to true to have a different order of features everytime the view is presented
    ///   - sorting: If set, will be used for sorting features.
    ///   - allowVotes: Set this to true to if you want to let users vote. Set it to false for read-only mode. This can be used to only let paying users vote for example.
    ///   - allowSearching: Set this to true to if you want to add a search bar so users can filter which features are shown.
    public init(sidetrackRoadmapId: String,
                style: RoadmapStyle = RoadmapTemplate.standard.style,
                shuffledOrder: Bool = false,
                sorting: (@Sendable (RoadmapFeature, RoadmapFeature) -> Bool)? = nil,
                allowVotes: Bool = true,
                allowSearching: Bool = false,
                allowsFilterByStatus: Bool = false) {
        
        guard sidetrackRoadmapId.isEmpty == false else {
            fatalError("Must provide a valid Sidetrack roadmap ID")
        }
        
        self.init(
            roadmapJSONURL: URL(string: "https://roadmap.sidetrack.app/roadmap/\(sidetrackRoadmapId)"),
            voter: FeatureVoterSidetrack(), style: style,
            shuffledOrder: shuffledOrder,
            sorting: sorting,
            allowVotes: allowVotes,
            allowSearching: allowSearching,
            allowsFilterByStatus: allowsFilterByStatus
        )
    }

    /// Creates a new Roadmap configuration instance.
    /// - Parameters:
    ///   - roadmapRequest: The Request pointing to the web endpoint.
    ///   - voter: The interface to use for retrieving and persisting votes.
    ///   - fetcher: The interface to fetch in the `RoadmapFeature` format
    ///   - style: Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    ///   - shuffledOrder: Set this to true to have a different order of features everytime the view is presented
    ///   - sorting: If set, will be used for sorting features.
    ///   - allowVotes: Set this to true to if you want to let users vote. Set it to false for read-only mode. This can be used to only let paying users vote for example.
    ///   - allowSearching: Set this to true to if you want to add a search bar so users can filter which features are shown.
    public init(
        roadmapRequest: URLRequest,
        voter: FeatureVoter,
        fetcher: FeaturesFetcher,
        style: RoadmapStyle = RoadmapTemplate.standard.style,
        shuffledOrder: Bool = false,
        sorting: (@Sendable (RoadmapFeature, RoadmapFeature) -> Bool)? = nil,
        allowVotes: Bool = true,
        allowSearching: Bool = false,
        allowsFilterByStatus: Bool = false
    ) {
        self.roadmapRequest = roadmapRequest
        self.voter = voter
        self.fetcher = fetcher
        self.style = style
        self.shuffledOrder = shuffledOrder
        self.sorting = sorting
        self.allowVotes = allowVotes
        self.allowSearching = allowSearching
        self.allowsFilterByStatus = allowsFilterByStatus
    }
}

extension RoadmapConfiguration {
    static func sampleURL() -> RoadmapConfiguration {
        .init(sidetrackRoadmapId: "669827fe83191f8a3a802b4d")
    }
}
