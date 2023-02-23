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
    private let alreadyVoted: () -> ()

    @Published var voteCount = 0

    init(feature: RoadmapFeature,
         configuration: RoadmapConfiguration,
         alreadyVoted: @escaping () -> ()) {
        self.feature = feature
        self.configuration = configuration
        self.alreadyVoted = alreadyVoted
    }
    
    @MainActor
    func getCurrentVotes() async {
        voteCount = await FeatureVotingCountFetcher(feature: feature, namespace: configuration.namespace).fetch()
    }

    func vote(onSuccess: @escaping () -> ()) {
        guard !feature.hasVoted else {
            self.alreadyVoted()
            return
        }
        Task { @MainActor in
            let newCount = await FeatureVoter(feature: feature, namespace: configuration.namespace).vote()
            voteCount = newCount ?? (voteCount + 1)
            onSuccess()
        }
    }
}
