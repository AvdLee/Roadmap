//
//  RoadmapConfiguration.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation
import SwiftUI

public struct RoadmapConfiguration {
    /// The URL pointing to the JSON in the `RoadmapFeature` format.
    public let roadmapJSONURL: URL

    /// A unique namespace to use matching your app.
    /// See `https://countapi.xyz/` for more information.
    /// Defaults to your main bundle identifier.
    public let namespace: String
    
    /// Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    public let style: RoadmapStyle
    
    /// Set this to true to have a different order of features everytime the view is presented
    public let shuffledOrder: Bool
    
    /// Set this to true to if you want to let users vote. Set it to false for read-only mode. This can be used to only let paying users vote for example.
    public let allowVotes: Bool
    
    /// Set this to true to if you want to add a search bar so users can filter which features are shown.
    public let allowSearching: Bool

    /// Creates a new Roadmap configuration instance.
    /// - Parameters:
    ///   - roadmapJSONURL: The URL pointing to the JSON in the `RoadmapFeature` format.
    ///   - namespace: A unique namespace to use matching your app.
    ///   See `https://countapi.xyz/` for more information.
    ///   Defaults to your main bundle identifier.
    ///   - style: Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used.
    public init(roadmapJSONURL: URL, namespace: String? = nil, style: RoadmapStyle = RoadmapTemplate.standard.style, shuffledOrder: Bool = false, allowVotes: Bool = true, allowSearching: Bool = false) {
        guard let namespace = namespace ?? Bundle.main.bundleIdentifier else {
            fatalError("Missing namespace")
        }

        self.roadmapJSONURL = roadmapJSONURL
        self.namespace = namespace
        self.style = style
        self.shuffledOrder = shuffledOrder
        self.allowVotes = allowVotes
        self.allowSearching = allowSearching
    }
}

extension RoadmapConfiguration {
    static func sample() -> RoadmapConfiguration {
        .init(roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!, namespace: "roadmaptest")
    }
}
