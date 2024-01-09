//
//  DailyChallengePresenter.swift
//  Nova
//
//  Created by Kelson Hartle on 1/8/24.
//

import Foundation

public struct DailyChallengeViewModel {
    public let hint: String
    public let correctAnswer: String
    public let challengeText: String
}

public final class DailyChallengePresenter {
    public static var title: String {
        return "Daily Challenges"
    }
    
    public static func map(_ dailyChallenge: DailyChallenge) -> DailyChallengeViewModel {
        return DailyChallengeViewModel(hint: dailyChallenge.hint, correctAnswer: dailyChallenge.correctAnswer, challengeText: dailyChallenge.challengeText)
    }
}
