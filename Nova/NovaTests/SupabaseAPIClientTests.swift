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
    struct Testing: Decodable {}
    func test_supabaseAPIClient_doesNotContact_DBClient_uponInit() {
        let (_, dbClient) = makeSUT()
        XCTAssertTrue(dbClient.messages.isEmpty)
    }
    
    func test_read_requestsFromCorrectDBTableName() async throws {
        let (sut, dbClient) = makeSUT()
        dbClient.throwErrorDuringRetrieval(anyNSError())
        do {
            let _: Testing = try await sut.readFromDatabase(tableName: .dailyChallenges)
        } catch {}
        XCTAssertEqual(dbClient.messages, [.read(.dailyChallenges)])
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
        
        func throwErrorDuringRetrieval(_ error: Error) {
            returnError = error
        }
    }
}
