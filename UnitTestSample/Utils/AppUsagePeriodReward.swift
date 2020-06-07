//
//  AppUsagePeriodReward.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

/// アプリ利用期間に対する報酬
///
/// 初回起動後、1日以上経過
///
/// 初回報酬付与後、3日以上経過
///
/// 二回目報酬付与後、5日以上経過
///
/// 前回報酬付与後、30日以上経過
enum AppUsagePeriodReward: Int {
    case none
    case one
    case two
    case more

    init() {
        let lastAppUsagePeriodRewardRawValue = AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue)
        self = AppUsagePeriodReward(rawValue: lastAppUsagePeriodRewardRawValue) ?? .none
    }

    /// アプリ利用期間が条件を満たしている場合は報酬を付与する
    /// - Parameters:
    ///   - currentDate: 現在日時
    ///   - rewards: 報酬を付与する場合のハンドラ
    ///   - noRewards: 報酬を付与しない場合のハンドラ
    func giveRewardsIfNeeded(currentDate: Date, rewards: @escaping(() -> Void), noRewards: (() -> Void)? = nil) {
        if self.shouldGiveRewards(currentDate: currentDate) {
            AppPreferences.shared.set(value: currentDate, forKey: .lastRewardDate)
            AppPreferences.shared.set(value: self.nextRawValue, forKey: .lastAppUsagePeriodRewardRawValue)
            rewards()
        }
        else {
            noRewards?()
        }
    }
}

extension AppUsagePeriodReward {

    // 次回の報酬までの日数
    private var daysUntilNextReward: CountablePartialRangeFrom<Int> {
        switch self {
            case .none:
                return 1...
            case .one:
                return 3...
            case .two:
                return 5...
            case .more:
                return 30...
        }
    }

    /// rawValueをインクリメントする
    private var nextRawValue: Int {
        switch self {
            case .more:
                return AppUsagePeriodReward.more.rawValue
            default:
                return self.rawValue + 1
        }
    }

    /// 報酬を付与するかどうか判定する
    private func shouldGiveRewards(currentDate: Date) -> Bool {
        // 初回起動日時(nilではない想定)
        let firstLaunchingDate = AppPreferences.shared.date(forKey: .firstLaunchingDate)!
        print("firstLaunchingDate: \(firstLaunchingDate)")
        // 前回報酬付与日時
        let lastRewardDate = AppPreferences.shared.date(forKey: .lastRewardDate)
        print("lastRewardDate: \(String(describing: lastRewardDate))")
        // 前回報酬付与日時がnilの場合は、初回起動日時を起算日とする
        let referenceDate = lastRewardDate ?? firstLaunchingDate
        print("referenceDate: \(referenceDate)")

        let elapsedDays = Calendar.gregorianJST().elapsedDays(from: referenceDate, to: currentDate)
        print("elapsedDays: \(elapsedDays)")
        return self.daysUntilNextReward.contains(elapsedDays)
    }
}
