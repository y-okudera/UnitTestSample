//
//  Calendar+.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

extension Calendar {
    
    /// Calendarインスタンス
    ///
    /// Locale(identifier: "ja_JP")
    ///
    /// TimeZone(identifier: "Asia/Tokyo")!
    static func gregorianJST() -> Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = .jaJp
        calendar.timeZone = .jst
        return calendar
    }
    
    /// 経過日数を計算する
    /// - Parameters:
    ///   - starting: 起算日
    ///   - ending: 日付
    /// - Returns: 日数の差分
    /// - Note: 24時間経過していない場合は1日と見なさない
    /// - Warning: endingの方がstartingより過去の場合は、マイナスになる
    func elapsedDays(from starting: Date, to ending: Date) -> Int {
        let days = self.dateComponents([.day], from: starting, to: ending)
        guard let day = days.day else {
            assertionFailure("dateComponents.day is nil. (Calendar instance: \(self))")
            return 0
        }
        return day
    }
    
    /// 起算日からn日後のDateを取得する
    /// - Parameters:
    ///   - date: 起算日
    ///   - days: n日
    /// - Returns: 起算日からn日後のDate
    func move(_ date: Date, byDays days: Int) -> Date {
        return self.date(byAdding: .day, value: days, to: date)!
    }
}
