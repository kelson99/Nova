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
    func test_supabaseAPIClient_doesNotContact_DBClient_uponInit() async throws {
        let dbClient = MockSupabaseDatabaseClient()
        let apiClient = SupabaseAPIClient(databaseClient: dbClient)
        XCTAssertTrue(dbClient.messages.isEmpty)
    }
    
    private class MockSupabaseDatabaseClient: SupabaseDatabaseClient {
        enum Message {
            case retrieve(SupabaseTableName)
        }
        
        private(set) var messages = [Message]()
        var returnResult: Data?
        var returnError: Error?
        
        func read(from tableName: SupabaseTableName) async throws -> Data {
            messages.append(.retrieve(tableName))
            return returnResult!
        }
        
        func throwErrorDuringRetrieval(_ error: Error) {
            returnError = error
        }
    }
}
