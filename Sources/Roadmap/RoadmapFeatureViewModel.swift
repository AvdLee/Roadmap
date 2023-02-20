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
    let configuration: RoadmapConfiguration

    @Published var voteCount = 0

    init(feature: RoadmapFeature, configuration: RoadmapConfiguration) {
        self.feature = feature
        self.configuration = configuration
    }
    
    @MainActor
    func getCurrentVotes() async {
        voteCount = await FeatureVotingCountFetcher(feature: feature, configuration: configuration).fetch()
    }

    func vote() {
        guard !feature.hasVoted else {
            print("already voted for this, can't vote again")
            return
        }
        Task { @MainActor in
            let newCount = await FeatureVoter(feature: feature, configuration: configuration).vote()
            voteCount = newCount ?? (voteCount + 1)
        }
    }
}
