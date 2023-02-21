//
//  RoadmapFeature.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation

struct RoadmapFeature: Codable, Identifiable {
    let id: String
    
    var title: String {
        localizedTitle.currentLocal ?? originalTitle ?? "N/A"
    }
    var description: String? {
        localizedDescription.currentLocal ?? originalDescription
    }
    var status: String? {
        localizedStatus.currentLocal ?? originalStatus
    }
    
    let originalTitle: String?
    var originalStatus: String? = nil
    var originalDescription : String? = nil
    
    private var localizedTitle: [LocalizedItem]? = nil
    private var localizedStatus: [LocalizedItem]? = nil
    private var localizedDescription: [LocalizedItem]? = nil
    
    
    var hasVoted: Bool {
        get {
            guard let votes = UserDefaults.standard.array(forKey: "roadmap_votes") as? [String] else { return false }
            return votes.contains(id)
        }
        nonmutating set {
            var votes = (UserDefaults.standard.array(forKey: "roadmap_votes") as? [String]) ?? []
            if newValue {
                votes.append(id)
            } else {
                votes.removeAll(where: { $0 == id })
            }
            UserDefaults.standard.set(votes, forKey: "roadmap_votes")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case originalTitle = "title"
        case originalStatus = "status"
        case originalDescription = "description"
        case localizedTitle
        case localizedStatus
        case localizedDescription
    }
}

struct LocalizedItem: Codable {
    let language: String
    let value: String
}

extension [LocalizedItem]? {
    var currentLocal: String? {
        self?.first(where: { $0.language == L.code })?.value
    }
}

extension RoadmapFeature {
    static func sample() -> RoadmapFeature {
        .init(id: UUID().uuidString, originalTitle: "WatchOS Support", originalStatus: "Backlog")
    }
}
