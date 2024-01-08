//
//  DailyChallengeLoaderTests.swift
//  NovaTests
//
//  Created by Kelson Hartle on 1/7/24.
//

import Nova
import XCTest

final class DailyChallengeLoaderTests: XCTestCase {
    func test_init_doesNotMessageSupabseAPIClient() {
        let (_, api) = createSUT()
        XCTAssertTrue(api.messages.isEmpty)
    }
    
    func test_load_usesCorrectTableName() async throws {
        let (sut, api) = createSUT()
        let _ = try await sut.load()
        XCTAssertEqual(api.messages, [.read(.dailyChallenges)])
    }
    
    func test_load_sucessfullyDeliversArrayOfDailyChallenges() async throws {
        let (sut, api) = createSUT()
        let expectedDailyChallenges = createDailyChallenges()
        try await expect(sut, toReturn: expectedDailyChallenges, when: {
            api.returnResultDuringRead(dailyChallenges: expectedDailyChallenges)
        })
    }
    
    func test_load_deliversError_onAnyError() async throws {
        let (sut, api) = createSUT()
        let anyError = anyNSError()
        let expectedDailyChallenges = createDailyChallenges()
        try await expect(sut, toReturn: anyError, when: {
            api.returnErrorDuringRead(anyError)
        })
    }
    
    private func expect(_ sut: RemoteDailyChallengeLoader, toReturn expectedResult: [DailyChallenge], when action: () -> Void, file: StaticString = #file, line: UInt = #line) async throws {
        action()
        do {
            let dailyChallenges = try await sut.load()
            XCTAssertEqual(dailyChallenges, expectedResult)
        } catch {
            XCTFail("Expected no failures")
        }
    }
    
    private func expect(_ sut: RemoteDailyChallengeLoader, toReturn expectedError: Error, when action: () -> Void, file: StaticString = #file, line: UInt = #line) async throws {
        action()
        do {
            let _ = try await sut.load()
        } catch {
            XCTAssertEqual(expectedError as NSError, error as NSError)
        }
    }
    
    private func createSUT() -> (sut: RemoteDailyChallengeLoader, api: SupabaseAPIClientSpy) {
        let supabaseAPIClientSpy = SupabaseAPIClientSpy()
        let sut = RemoteDailyChallengeLoader(supabaseAPIClient: supabaseAPIClientSpy)
        trackForMemoryLeaks(supabaseAPIClientSpy)
        trackForMemoryLeaks(sut)
        return (sut, supabaseAPIClientSpy)
    }
    
    private func createDailyChallenges() -> [DailyChallenge] {
        return [
            DailyChallenge(id: 0, hint: "", correctAnswer: "", challengeText: "", challengeID: 0),
            DailyChallenge(id: 1, hint: "", correctAnswer: "", challengeText: "", challengeID: 1)
        ]
    }
    
    private class SupabaseAPIClientSpy: SupabaseClient {
        enum Message: Equatable {
            case read(SupabaseTableName)
        }
        private(set) var messages: [Message] = []
        var returnError: Error?
        var returnResult = [DailyChallenge(id: 0, hint: "", correctAnswer: "", challengeText: "", challengeID: 0)]
        
        func readFromDatabase<T>(tableName: SupabaseTableName) async throws -> T where T : Decodable {
            messages.append(.read(tableName))
            if let error = returnError {
               throw error
            }
            return returnResult as! T
        }
        
        func returnResultDuringRead(dailyChallenges: [DailyChallenge]) {
            returnResult = dailyChallenges
        }
        
        func returnErrorDuringRead(_ error: Error) {
            returnError = error
        }
    }
}


