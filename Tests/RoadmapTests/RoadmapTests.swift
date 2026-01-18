@testable import Roadmap
import XCTest

final class RoadmapTests: XCTestCase {
    @MainActor
    func testFeatureVoter() async throws {
        let featureID = "test"
        
        let feature = RoadmapFeature.sample(id: featureID)
        feature.hasVoted = false
        
        let voter = InMemoryFeatureVoter()
        voter.count[featureID] = 1
        
        let configuration = RoadmapConfiguration(
            roadmapJSONURL: URL(string: "https://www.avanderlee.com/")!,
            voter: voter
        )
        
        let model = RoadmapFeatureViewModel(feature: feature, configuration: configuration)
        XCTAssertEqual(model.voteCount, 0)
        
        await model.getCurrentVotes()
        XCTAssertEqual(model.voteCount, 1)
        
        await model.vote()
        XCTAssertEqual(model.voteCount, 2)
        XCTAssertTrue(feature.hasVoted)
        
        await model.unvote()
        XCTAssertEqual(model.voteCount, 1)
        XCTAssertFalse(feature.hasVoted)
    }

    @MainActor
    func testFeatureFetcher() async throws {
        let request =  URLRequest(url: URL(string: "http://localhost:3000/api")!)
        let fetcher = FeaturesFetcherMock()
        let voter = InMemoryFeatureVoter()
        let configuration = RoadmapConfiguration(
            roadmapRequest: request,
            voter: voter,
            fetcher: fetcher
        )

        let model = RoadmapViewModel(configuration: configuration)
        try await Task.sleep(nanoseconds: 500_000_000)
        let features = model.filteredFeatures
        XCTAssertTrue(features.count > 0)
    }
}

@MainActor
fileprivate class InMemoryFeatureVoter: FeatureVoter {
    var count: [String: Int] = [:]
    
    func fetch(for feature: RoadmapFeature) async -> Int {
        count[feature.id] ?? 0
    }
    
    func vote(for feature: RoadmapFeature) async -> Int? {
        count[feature.id] = await fetch(for: feature) + 1
        return count[feature.id]
    }
    
    func unvote(for feature: RoadmapFeature) async -> Int? {
        count[feature.id] = await fetch(for: feature) - 1
        return count[feature.id]
    }
}

fileprivate final class FeaturesFetcherMock: FeaturesFetcher {
    var featureRequest: URLRequest {
        URLRequest(url: URL(string: "http://localhost/api")!)
    }

    func fetch() async -> [Roadmap.RoadmapFeature] {
        [
            RoadmapFeature.sample(),
            RoadmapFeature.sample()
        ]
    }
}
