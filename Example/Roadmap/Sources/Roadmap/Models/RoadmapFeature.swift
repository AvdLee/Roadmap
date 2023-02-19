//
//  RoadmapFeature.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct RoadmapFeature: Codable, Identifiable {
    let id: String
    let title: String
    let status: String
}

extension RoadmapFeature {
    static func sample() -> RoadmapFeature {
        .init(id: UUID().uuidString, title: "WatchOS Support", status: "Backlog")
    }
}
