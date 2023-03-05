import XCTest
@testable import Roadmap

final class RoadmapTests: XCTestCase {
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
    }
}

class InMemoryFeatureVoter: FeatureVoter {
    var count: [String: Int] = [:]
    
    func fetch(for feature: RoadmapFeature) async -> Int {
        count[feature.id] ?? 0
    }
    
    func vote(for feature: RoadmapFeature) async -> Int? {
        count[feature.id] = await fetch(for: feature) + 1
        feature.hasVoted = true
        return count[feature.id]
    }
}
