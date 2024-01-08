//
//  SupabaseAPIClientTests.swift
//  NovaTests
//
//  Created by Kelson Hartle on 1/6/24.
//

import Supabase
import Nova
import XCTest

final class SupabaseAPIClientTests: XCTestCase {
    func test_supabaseAPIClient_doesNotContact_DBClient_uponInit() {
        let (_, dbClient) = makeSUT()
        XCTAssertTrue(dbClient.messages.isEmpty)
    }
    
    func test_read_requestsFromCorrectDBTableName() async throws {
        let (sut, dbClient) = makeSUT()
        dbClient.throwErrorDuringRetrieval(anyNSError())
        do {
            let _: DailyChallenge = try await sut.readFromDatabase(tableName: .dailyChallenges)
        } catch {}
        XCTAssertEqual(dbClient.messages, [.read(.dailyChallenges)])
    }
    
    func test_read_deliversDecodableType_onSuccesfulResponse() async throws {
        let (sut, dbClient) = makeSUT()
        let expectedChallenge = DailyChallenge(id: 1, hint: "", correctAnswer: "", challengeText: "", challengeID: 0)
        let expectedData = makeDailyChallengeData(expectedChallenge)
        
        try await expect(sut, toReturn: expectedChallenge, when: {
            dbClient.returnResultDuringRetrieval(data: expectedData)
        })
    }
    
    func test_read_deliversError_onAnyError() async throws {
        let (sut, dbClient) = makeSUT()
        let error = anyNSError()
        try await expect(sut, toReturn: error, when: {
            dbClient.throwErrorDuringRetrieval(error)
        })
    }
    
    func test_read_deliversError_onInvalidJSON() async throws {
        let (sut, dbClient) = makeSUT()
        let invalidJSONData = Data("invalid json".utf8)
        try await expect(sut, toReturn: SupabaseAPIClient.SupabaseAPIClientError.invalidData, when: {
            dbClient.returnResultDuringRetrieval(data: invalidJSONData)
        })
    }
    
    private func expect(_ sut: SupabaseAPIClient, toReturn expected: DailyChallenge, when action: () -> Void) async throws {
        action()
        do {
            let dailyChallenges: [DailyChallenge] = try await sut.readFromDatabase(tableName: .dailyChallenges)
            XCTAssertEqual(dailyChallenges, [expected])
        } catch {
            XCTFail("Expected no errors - \(error)")
        }
    }
    
    private func expect(_ sut: SupabaseAPIClient, toReturn expectedError: Error, when action: () -> Void) async throws {
        action()
        do {
            let _: [DailyChallenge] = try await sut.readFromDatabase(tableName: .dailyChallenges)
        } catch {
            XCTAssertEqual(error as NSError, expectedError as NSError)
        }
    }
    
    private func makeDailyChallengeData(_ dailyChallenge: DailyChallenge) -> Data {
        let json = [[
            "id": dailyChallenge.id,
            "hint": dailyChallenge.hint,
            "correct_answer": dailyChallenge.correctAnswer,
            "challenge_text": dailyChallenge.challengeText,
            "challenge_id": dailyChallenge.challengeID
        ]] as [[String : Any]]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func makeSUT() -> (sut: SupabaseAPIClient, dbClient: MockSupabaseDatabaseClient) {
        let dbClient = MockSupabaseDatabaseClient()
        let sut = SupabaseAPIClient(databaseClient: dbClient)
        trackForMemoryLeaks(dbClient)
        trackForMemoryLeaks(sut)
        return (sut, dbClient)
    }
    
    private class MockSupabaseDatabaseClient: SupabaseDatabaseClient {
        enum Message: Equatable {
            case read(SupabaseTableName)
        }
        
        private(set) var messages = [Message]()
        var returnResult: Data?
        var returnError: Error?
        
        func read(from tableName: SupabaseTableName) async throws -> Data {
            messages.append(.read(tableName))
            if let error = returnError {
                throw error
            }
            return returnResult!
        }
        
        func returnResultDuringRetrieval(data: Data) {
            returnResult = data
        }
        
        func throwErrorDuringRetrieval(_ error: Error) {
            returnError = error
        }
    }
}
