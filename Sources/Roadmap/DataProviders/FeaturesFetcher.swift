//
//  FeaturesFetcher.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation
import OSLog

public protocol FeaturesFetcher: Sendable {
    var featureRequest: URLRequest { get }

    func fetch() async -> [RoadmapFeature] 
}
