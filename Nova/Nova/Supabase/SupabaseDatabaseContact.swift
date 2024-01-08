//
//  SupabaseDatabaseContact.swift
//  Nova
//
//  Created by Kelson Hartle on 1/8/24.
//

import Supabase

public final class SupabaseDatabaseContact: SupabaseDatabaseClient {
    private let client = SupabaseClient(supabaseURL: SupabaseAPIInfo.url, supabaseKey: SupabaseAPIInfo.key)
    
    public init() {}
    
    public func read(from tableName: SupabaseTableName) async throws -> Data {
        do {
            let supabaseResponse = try await client.database
                .from(tableName.rawValue)
                .select()
                .execute()
            return supabaseResponse.data
        } catch {
            throw error
        }
    }
}
