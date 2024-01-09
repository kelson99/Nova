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
}
