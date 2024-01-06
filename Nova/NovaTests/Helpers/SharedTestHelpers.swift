//
//  SharedTestHelpers.swift
//  NovaTests
//
//  Created by Kelson Hartle on 1/6/24.
//

import Foundation

func anyNSError() -> NSError {
    return NSError(domain: "any error", code: 0)
}

func anyData() -> Data {
    return Data(capacity: 0)
}
