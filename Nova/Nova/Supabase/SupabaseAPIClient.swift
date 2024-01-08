//
//  SupabaseAPIClient.swift
//  Nova
//
//  Created by Kelson Hartle on 1/6/24.
//

import Supabase

final public class SupabaseAPIClient: SupabaseService {
    public enum SupabaseAPIClientError: Error {
        case invalidData
    }
    
    public let databaseClient: SupabaseDatabaseClient
    public init(databaseClient: SupabaseDatabaseClient) {
        self.databaseClient = databaseClient
    }

    public func readFromDatabase<T:Decodable>(tableName: SupabaseTableName) async throws -> T {
            let data = try await databaseClient.read(from: tableName)
            return try decode(from: data)
    }
    
    private func decode<T:Decodable>(from data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw SupabaseAPIClientError.invalidData
        }
    }
}
