//
//  SupabaseClient.swift
//  Nova
//
//  Created by Kelson Hartle on 1/6/24.
//

import Foundation

public protocol SupabaseClient {
    func readFromDatabase<T:Decodable>(tableName: SupabaseTableName) async throws -> T
}
