//
//  DailyChallengePresenterTests.swift
//  NovaTests
//
//  Created by Kelson Hartle on 1/8/24.
//

import Nova
import XCTest

class DailyChallengePresenterTests: XCTestCase {
    func test_map_creates_viewModel() {
        let dailyChallenge = DailyChallenge(id: 0, hint: "", correctAnswer: "", challengeText: "", challengeID: 0)
        let viewModel = DailyChallengePresenter.map(dailyChallenge)
        
        XCTAssertEqual(viewModel.hint, viewModel.hint)
        XCTAssertEqual(viewModel.correctAnswer, viewModel.challengeText)
        XCTAssertEqual(viewModel.challengeText, viewModel.challengeText)
    }
    
    // MARK: - Helpers
    
    private func localized(_ key: String, file: StaticString = #filePath, line: UInt = #line) -> String {
        let table = "Localizable"
        let bundle = Bundle(for: DailyChallengePresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
}
