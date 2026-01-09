//
//  FeatureVoterCloudKit.swift
//  Roadmap
//
//  Created by Ezequiel dos Santos on 09/01/2026.
//


#if canImport(CloudKit)

import CloudKit
import Foundation
import os

public struct FeatureVoterCloudKit: FeatureVoter {

    public init(
        container: CKContainer = .default(),
        recordNamePrefix: String = "roadmap"
    ) {
        self.backend = Backend(
            container: container,
            recordNamePrefix: recordNamePrefix
        )
    }

    /// Fetches the current count for the given feature.
    /// - Returns: The current `count`, else `0` if unsuccessful.
    public func fetch(for feature: RoadmapFeature) async -> Int {
        guard feature.hasNotFinished else { return 0 }
        return await backend.fetch(forFeatureID: feature.id)
    }

    /// Votes for the given feature.
    /// - Returns: The new `count` if successful.
    public func vote(for feature: RoadmapFeature) async -> Int? {
        guard feature.hasNotFinished else { return nil }
        return await backend.vote(true, forFeatureID: feature.id)
    }

    /// Unvotes for the given feature.
    /// - Returns: The new `count` if successful.
    public func unvote(for feature: RoadmapFeature) async -> Int? {
        guard feature.hasNotFinished else { return nil }
        return await backend.vote(false, forFeatureID: feature.id)
    }

    // MARK: - Private

    private let backend: Backend
}

// MARK: - Our "Backend"

private struct Backend: @unchecked Sendable {

    // Schema names. Keep these identical across apps using same container.
    private enum Schema {
        static let countsRecordType = "RoadmapFeatureCount"
        static let votesRecordType  = "RoadmapUserVote"

        static let keyField     = "key"
        static let countField   = "count"
        static let voteKeyField = "featureKey"
    }

    private let container: CKContainer
    private let publicDB: CKDatabase
    private let privateDB: CKDatabase
    private let recordNamePrefix: String
    private let log = Logger(subsystem: "com.roadmap", category: "FeatureVoterCloudKit")

    init(container: CKContainer, recordNamePrefix: String) {
        self.container = container
        self.publicDB = container.publicCloudDatabase
        self.privateDB = container.privateCloudDatabase
        self.recordNamePrefix = recordNamePrefix
    }

    func fetch(forFeatureID featureID: String) async -> Int {
        let key = normalize(featureID)
        guard !key.isEmpty else { return 0 }

        do {
            guard await cloudAvailable() else { return 0 }
            let record = try await fetchOrCreateCountRecord(key: key)
            return int(from: record[Schema.countField]) ?? 0
        } catch {
            logError("fetch", key: key, error: error)
            return 0
        }
    }

    func vote(_ voted: Bool, forFeatureID featureID: String) async -> Int? {
        let key = normalize(featureID)
        guard !key.isEmpty else { return nil }

        do {
            guard await cloudAvailable() else { return nil }

            let hasMarker = try await voteMarkerExists(key: key)

            if voted {
                if hasMarker { return await fetch(forFeatureID: key) }

                try await createVoteMarker(key: key)
                do {
                    return try await updateCount(key: key, delta: +1, floorAtZero: false)
                } catch {
                    _ = try? await deleteVoteMarker(key: key) // best-effort rollback
                    throw error
                }
            } else {
                if !hasMarker { return await fetch(forFeatureID: key) }

                try await deleteVoteMarker(key: key)
                do {
                    return try await updateCount(key: key, delta: -1, floorAtZero: true)
                } catch {
                    _ = try? await createVoteMarker(key: key) // best-effort rollback
                    throw error
                }
            }
        } catch {
            logError(voted ? "vote" : "unvote", key: key, error: error)
            return nil
        }
    }

    // MARK: - Cloud availability

    private func cloudAvailable() async -> Bool {
        do {
            let status = try await container.accountStatus()
            return status == .available
        } catch {
            logError("accountStatus", key: nil, error: error)
            return false
        }
    }

    // MARK: - Records

    private func countRecordID(key: String) -> CKRecord.ID {
        CKRecord.ID(recordName: "\(recordNamePrefix)_count_\(hash64Hex(key))")
    }

    private func voteRecordID(key: String) -> CKRecord.ID {
        CKRecord.ID(recordName: "\(recordNamePrefix)_vote_\(hash64Hex(key))")
    }

    private func fetchOrCreateCountRecord(key: String) async throws -> CKRecord {
        let id = countRecordID(key: key)

        do {
            return try await publicDB.record(for: id)
        } catch let ck as CKError where ck.code == .unknownItem {
            let record = CKRecord(recordType: Schema.countsRecordType, recordID: id)
            record[Schema.keyField] = key as NSString
            record[Schema.countField] = NSNumber(value: Int64(0))

            do {
                return try await publicDB.save(record)
            } catch let ck2 as CKError where ck2.code == .serverRecordChanged {
                return try await publicDB.record(for: id)
            }
        }
    }

    private func updateCount(key: String, delta: Int64, floorAtZero: Bool) async throws -> Int {
        // optimistic concurrency loop
        let maxAttempts = 6

        for attempt in 1...maxAttempts {
            let record = try await fetchOrCreateCountRecord(key: key)

            let current = int64(from: record[Schema.countField]) ?? 0
            var next = current &+ delta
            if floorAtZero { next = max(0, next) }

            record[Schema.countField] = NSNumber(value: next)

            do {
                let saved = try await publicDB.save(record)
                return Int(int64(from: saved[Schema.countField]) ?? next)
            } catch let ck as CKError where ck.code == .serverRecordChanged && attempt < maxAttempts {
                try await backoff(attempt: attempt)
                continue
            }
        }

        // fallback: return whatever is currently stored
        return await fetch(forFeatureID: key)
    }

    // MARK: - Vote marker (private DB)

    private func voteMarkerExists(key: String) async throws -> Bool {
        let id = voteRecordID(key: key)
        do {
            _ = try await privateDB.record(for: id)
            return true
        } catch let ck as CKError where ck.code == .unknownItem {
            return false
        }
    }

    private func createVoteMarker(key: String) async throws {
        let id = voteRecordID(key: key)
        let record = CKRecord(recordType: Schema.votesRecordType, recordID: id)
        record[Schema.voteKeyField] = key as NSString

        do {
            _ = try await privateDB.save(record)
        } catch let ck as CKError where ck.code == .serverRecordChanged {
            // race: already exists
            return
        }
    }

    private func deleteVoteMarker(key: String) async throws {
        let id = voteRecordID(key: key)
        do {
            _ = try await privateDB.deleteRecord(withID: id)
        } catch let ck as CKError where ck.code == .unknownItem {
            // already deleted
            return
        }
    }

    // MARK: - Helpers

    private func normalize(_ s: String) -> String {
        s.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    }

    private func hash64Hex(_ s: String) -> String {
        var hash: UInt64 = 14695981039346656037
        let prime: UInt64 = 1099511628211
        for b in s.utf8 {
            hash ^= UInt64(b)
            hash &*= prime
        }
        return String(format: "%016llx", hash)
    }

    private func backoff(attempt: Int) async throws {
        // 30ms, 60ms, 120ms, 240ms, ... capped at 500ms
        let base: UInt64 = 30_000_000
        let shift = UInt64(max(0, attempt - 1))
        let delay = min(base << shift, 500_000_000)
        try await Task.sleep(nanoseconds: delay)
    }

    private func int(from any: Any?) -> Int? {
        if let v = any as? Int { return v }
        if let v = any as? Int64 { return Int(v) }
        if let v = any as? NSNumber { return v.intValue }
        return nil
    }

    private func int64(from any: Any?) -> Int64? {
        if let v = any as? Int64 { return v }
        if let v = any as? Int { return Int64(v) }
        if let v = any as? NSNumber { return v.int64Value }
        return nil
    }

    private func logError(_ operation: String, key: String?, error: Error) {
        if let key {
            log.error("[\(operation, privacy: .public)] key=\(key, privacy: .public) error=\(String(describing: error), privacy: .public)")
        } else {
            log.error("[\(operation, privacy: .public)] error=\(String(describing: error), privacy: .public)")
        }
    }
}

#else

import Foundation

public struct FeatureVoterCloudKit: FeatureVoter {
    public init() {}
    public func fetch(for feature: RoadmapFeature) async -> Int { 0 }
    public func vote(for feature: RoadmapFeature) async -> Int? { nil }
    public func unvote(for feature: RoadmapFeature) async -> Int? { nil }
}

#endif
