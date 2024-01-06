//
//  SupabaseDatabaseClient.swift
//  Nova
//
//  Created by Kelson Hartle on 1/6/24.
//

import Foundation

public protocol SupabaseDatabaseClient {
    func read(from tableName: SupabaseTableName) async throws -> Data
}
