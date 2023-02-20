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
    /// Recommended: your bundle identifier.
    public let namespace: String
    
    /// Pick a `RoadmapStyle` that fits your app best. By default the `.standard` option is used
    public let style: RoadmapStyle
    
    /// The main tintColor for the roadmap views
    public let tintColor : Color

    public init(roadmapJSONURL: URL, namespace: String, style: RoadmapStyle = RoadmapTemplate.standard.style, tint: Color = .accentColor) {
        self.roadmapJSONURL = roadmapJSONURL
        self.namespace = namespace
        self.style = style
        self.tintColor = tint
    }
    
}

extension RoadmapConfiguration {
    static func sample() -> RoadmapConfiguration {
        .init(roadmapJSONURL: URL(string: "https://simplejsoncms.com/api/vq2juq1xhg")!, namespace: "roadmaptest")
    }
}
