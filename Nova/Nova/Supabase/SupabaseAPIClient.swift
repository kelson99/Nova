//
//  SupabaseAPIClient.swift
//  Nova
//
//  Created by Kelson Hartle on 1/6/24.
//

import Supabase

final public class SupabaseAPIClient: SupabaseClient {
    public enum SupabaseAPIClientError: Error {
        case invalidData
    }
    
    public let databaseClient: SupabaseDatabaseClient
    public init(databaseClient: SupabaseDatabaseClient) {
        self.databaseClient = databaseClient
    }

    public func readFromDatabase<T:Decodable>(tableName: SupabaseTableName) async throws -> T {
        do {
            let data = try await databaseClient.read(from: tableName)
            return try getDecodedObject(from: data)
        } catch  {
            throw error
        }
    }
    
    private func getDecodedObject<T:Decodable>(from data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            throw SupabaseAPIClientError.invalidData
        }
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
