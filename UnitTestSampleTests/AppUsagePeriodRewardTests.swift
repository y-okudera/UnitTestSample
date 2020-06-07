//
//  AppUsagePeriodRewardTests.swift
//  UnitTestSampleTests
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

@testable import UnitTestSample
import XCTest

final class AppUsagePeriodRewardTests: XCTestCase {

    /// 各テスト前に1回ずつ呼ばれる
    override func setUp() {
        AppPreferences.shared.removeObject(forKey: .firstLaunchingDate)
        AppPreferences.shared.removeObject(forKey: .lastRewardDate)
        AppPreferences.shared.removeObject(forKey: .lastAppUsagePeriodRewardRawValue)

        // 初回起動日時
        let firstLaunchingDate = "2020/06/01 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: firstLaunchingDate, forKey: .firstLaunchingDate)
    }

    /// 各テスト後に1回ずつ呼ばれる
    override func tearDown() {
        
    }

    /// LastRewardDateを検証する
    private func verifyLastRewardDate(_ result: Date?, expected: Date?) {
        XCTAssertEqual(result, expected)
    }

    /// LastAppUsagePeriodRewardRawValueを検証する
    private func verifyLastAppUsagePeriodRewardRawValue(_ result: Int?, expected: Int) {
        XCTAssertEqual(result, expected)
    }
}

extension AppUsagePeriodRewardTests {

    func test_過去リワード0回_初回起動から1日未満起動() {

        // Setup

        let currentDate = "2020/06/02 08:59:59 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        let expectation = self.expectation(description: "過去リワード0回_リワード無しのテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: {
            XCTAssert(false, "期待値は、リワード無しのためNG")
        }, noRewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: nil
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 0
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_過去リワード0回_初回起動から1日後起動() {

        // Setup

        let currentDate = "2020/06/02 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        let expectation = self.expectation(description: "初回リワード付与のテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: currentDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 1
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}

extension AppUsagePeriodRewardTests {
    func test_過去リワード1回_前回リワードから3日未満起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/02 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 1, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 2)
        let expectation = self.expectation(description: "過去リワード1回_リワード無しのテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: {
            XCTAssert(false, "期待値は、リワード無しのためNG")
        }, noRewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: lastRewardDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 1
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_過去リワード1回_前回リワードから3日以上経過起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/02 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 1, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 3)
        let expectation = self.expectation(description: "過去リワード1回_2回目のリワード付与のテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: currentDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 2
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}

extension AppUsagePeriodRewardTests {
    func test_過去リワード2回_前回リワードから5日未満起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/05 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 2, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 4)
        let expectation = self.expectation(description: "過去リワード2回_リワード無しのテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: {
            XCTAssert(false, "期待値は、リワード無しのためNG")
        }, noRewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: lastRewardDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 2
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_過去リワード2回_前回リワードから5日以上経過起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/05 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 2, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 5)
        let expectation = self.expectation(description: "過去リワード2回_3回目のリワード付与のテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: currentDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 3
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}

extension AppUsagePeriodRewardTests {
    func test_過去リワード3回_前回リワードから30日未満起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/10 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 3, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 29)
        let expectation = self.expectation(description: "過去リワード3回_リワード無しのテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: {
            XCTAssert(false, "期待値は、リワード無しのためNG")
        }, noRewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: lastRewardDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 3
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

    func test_過去リワード3回_前回リワードから30日以上経過起動() {

        // Setup

        // 基準となる日時（前回リワード日時）
        let lastRewardDate = "2020/06/10 09:00:00 +09:00".toDate(with: "yyyy/MM/dd HH:mm:ss Z")!
        AppPreferences.shared.set(value: lastRewardDate, forKey: .lastRewardDate)

        AppPreferences.shared.set(value: 3, forKey: .lastAppUsagePeriodRewardRawValue)

        let currentDate = Calendar.gregorianJST().move(lastRewardDate, byDays: 30)
        let expectation = self.expectation(description: "過去リワード3回_4回目のリワード付与のテスト")

        // Exercise

        AppUsagePeriodReward().giveRewardsIfNeeded(currentDate: currentDate, rewards: { [weak self] in

            // Verify

            self?.verifyLastRewardDate(
                AppPreferences.shared.date(forKey: .lastRewardDate),
                expected: currentDate
            )
            self?.verifyLastAppUsagePeriodRewardRawValue(
                AppPreferences.shared.int(forKey: .lastAppUsagePeriodRewardRawValue),
                expected: 3
            )
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
}
