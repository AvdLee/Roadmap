//
//  RoadmapFeatureViewModel.swift
//  Roadmap
//
//  Created by Antoine van der Lee on 19/02/2023.
//

import Foundation
import SwiftUI

final class RoadmapFeatureViewModel: ObservableObject {
    let feature: RoadmapFeature

    @Published var voteCount = 0

    init(feature: RoadmapFeature) {
        self.feature = feature
    }

    func getCurrentVotes() {
        Task { @MainActor in
            voteCount = await FeatureVotingCountFetcher(feature: feature).fetch()
        }
    }

    func vote() {
        guard !feature.hasVoted else {
            print("already voted for this, can't vote again")
            return
        }
        Task { @MainActor in
            let newCount = await FeatureVoter(feature: feature).vote()
            voteCount = newCount ?? (voteCount + 1)
        }
    }
}
