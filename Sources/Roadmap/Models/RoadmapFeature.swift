//
//  RoadmapFeature.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

public struct RoadmapFeature: Codable, Identifiable, Sendable {
    public let id: String
    public let title: String?
    public var status: String? = nil
    private var description : String? = nil
    private var localizedTitle: [LocalizedItem]? = nil
    private var localizedStatus: [LocalizedItem]? = nil
    private var localizedDescription: [LocalizedItem]? = nil
    public var votes: Int? = nil
    
    var localizedFeatureTitle: String {
        localizedTitle.currentLocal ?? title ?? "N/A"
    }
    var localizedFeatureDescription: String {
        localizedDescription.currentLocal ?? description ?? ""
    }
    var localizedFeatureStatus: String? {
        localizedStatus.currentLocal ?? status
    }
    var unlocalizedFeatureStatus: String { // for statusTintColor(unlocalizedFeatureStatus)
        status ?? ""
    }
    
    var isFinished: Bool? = nil
    
    var hasVoted: Bool {
        get {
            let votes = Set(UserDefaults.standard.stringArray(forKey: "roadmap_votes") ?? [])
            return votes.contains(id)
        }
        nonmutating set {
            var votes = Set(UserDefaults.standard.stringArray(forKey: "roadmap_votes") ?? [])
            if newValue {
                votes.insert(id)
            } else {
                votes.remove(id)
            }
            UserDefaults.standard.set(Array(votes), forKey: "roadmap_votes")
        }
    }
    
    var hasNotFinished: Bool {
        !(isFinished ?? false)
    }
}

struct LocalizedItem: Codable {
    let language: String
    let value: String
}

extension [LocalizedItem]? {
    var currentLocal: String? {
        self?.first(where: { $0.language == Language.code })?.value
    }
}

extension RoadmapFeature {
    static func sample(id: String = UUID().uuidString) -> RoadmapFeature {
        .init(id: id, title: "WatchOS Support", status: "Backlog")
    }
}
