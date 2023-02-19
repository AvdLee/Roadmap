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
    @AppStorage("votedIds") private var votedIds: [String] = []

    var hasVoted: Bool {
        votedIds.contains(feature.id)
    }

    init(feature: RoadmapFeature) {
        self.feature = feature
    }

    func getCurrentVotes() {
        Task {
            do {
                let urlString = "https://api.countapi.xyz/get/roadmaptest/feature\(feature.id)"
                let count: RoadmapFeatureVotingCount = try await JSONDataFetcher.loadJSON(fromURLString: urlString)

                await MainActor.run {
                    if let countValue = count.value {
                        voteCount = countValue
                    } else {
                        voteCount = 0
                    }
                }
            } catch {
                print("error:", error.localizedDescription)
            }
        }
    }

    func vote() {
        guard !hasVoted else {
            print("already voted for this, can't vote again")
            return
        }
        guard let url = URL(string: "https://api.countapi.xyz/hit/roadmaptest/feature\(feature.id)") else { return }
        let urlSession = URLSession(configuration: .ephemeral).dataTask(with: url) { (data, response, error) in
            if let error = error {
//                    completion(.failure(error))
                print("error while voting")
            }

            if let data = data {
//                    completion(.success(data))
                self.votedIds.append(self.feature.id)
                print("succesfully voted")
                self.voteCount += 1
            }
        }
        urlSession.resume()
    }
}
