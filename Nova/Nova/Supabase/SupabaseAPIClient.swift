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
        let data = try await databaseClient.read(from: tableName)
        let decoder = JSONDecoder()
        let decodedData = try decoder.decode(T.self, from: data)
        return decodedData
    }
}

public struct DailyChallenge: Decodable, Equatable {
    public let id: Int
    public let hint: String
    public let correctAnswer: String
    public let challengeText: String
    public let challengeID: Int
    
    public init(id: Int, hint: String, correctAnswer: String, challengeText: String, challengeID: Int) {
        self.id = id
        self.hint = hint
        self.correctAnswer = correctAnswer
        self.challengeText = challengeText
        self.challengeID = challengeID
    }
    
    enum CodingKeys: String, CodingKey {
        case id, hint
        case correctAnswer = "correct_answer"
        case challengeText = "challenge_text"
        case challengeID = "challenge_id"
    }
}
