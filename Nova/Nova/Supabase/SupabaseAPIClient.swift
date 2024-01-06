//
//  SupabaseAPIClient.swift
//  Nova
//
//  Created by Kelson Hartle on 1/6/24.
//

import Supabase

final public class SupabaseAPIClient: SupabaseClient {
    public let databaseClient: SupabaseDatabaseClient
    public init(databaseClient: SupabaseDatabaseClient) {
        self.databaseClient = databaseClient
    }

    public func readFromDatabase<T:Decodable>(tableName: SupabaseTableName) async throws -> T {
        let data = try await databaseClient.read(from: .dailyChallenges)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
}
