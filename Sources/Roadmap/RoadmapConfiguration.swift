//
//  RoadmapConfiguration.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

public struct RoadmapConfiguration {
    /// The URL pointing to the JSON in the `Roadmap` format.
    public let roadmapJSONURL: URL

    /// A unique namespace to use matching your app.
    /// See `https://countapi.xyz/` for more information.
    /// Recommended: your bundle identifier.
    public let namespace: String

    public init(roadmapJSONURL: URL, namespace: String) {
        self.roadmapJSONURL = roadmapJSONURL
        self.namespace = namespace
    }
}

extension RoadmapConfiguration {
    static func sample() -> RoadmapConfiguration {
        .init(roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!, namespace: "roadmaptest")
    }
}
