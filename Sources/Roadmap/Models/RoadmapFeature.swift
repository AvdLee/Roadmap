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
    var status: String? = nil
    var description : String? = nil
    
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
}

extension RoadmapFeature {
    static func sample() -> RoadmapFeature {
        .init(id: UUID().uuidString, title: "WatchOS Support", status: "Backlog")
    }
}
