//
//  DailyChallengeEndToEndTests.swift
//  DailyChallengeEndToEndTests
//
//  Created by Kelson Hartle on 1/8/24.
//

import Nova
import XCTest

final class DailyChallengeEndToEndTests: XCTestCase {
    func test_resultIsReceivedFromSupabaseTable() async throws {
        let dailyChallenges = try await getDailyChallenges()
        XCTAssertTrue(!dailyChallenges.isEmpty)
    }
    
    private func getDailyChallenges() async throws -> [DailyChallenge] {
        let supabaseDatabaseContact = SupabaseDatabaseContact()
        let supabaseAPIClient = SupabaseAPIClient(databaseClient: supabaseDatabaseContact)
        let dailyChallengeLoader = RemoteDailyChallengeLoader(supabaseAPIClient: supabaseAPIClient)
        trackForMemoryLeaks(supabaseDatabaseContact)
        trackForMemoryLeaks(supabaseAPIClient)
        trackForMemoryLeaks(dailyChallengeLoader)
        return try await dailyChallengeLoader.load()
    }
}
