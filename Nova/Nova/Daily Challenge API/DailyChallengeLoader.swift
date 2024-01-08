//
//  DailyChallengeLoader.swift
//  Nova
//
//  Created by Kelson Hartle on 1/7/24.
//

import Foundation

protocol DailyChallengeLoader {
    func load() async throws -> [DailyChallenge]
}

public final class RemoteDailyChallengeLoader: DailyChallengeLoader {
    let supabaseAPIClient: SupabaseClient
    
    public init(supabaseAPIClient: SupabaseClient) {
        self.supabaseAPIClient = supabaseAPIClient
    }
    
    public func load() async throws -> [DailyChallenge] {
        return try await supabaseAPIClient.readFromDatabase(tableName: .dailyChallenges)
    }
}
