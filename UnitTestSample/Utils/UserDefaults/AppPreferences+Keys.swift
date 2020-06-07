//
//  AppPreferences+Keys.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

// MARK: - Date value
extension AppPreferences: DateDefaults {

    enum DateKey: String {
        /// 初回起動日時
        case firstLaunchingDate
        /// 前回報酬付与日時
        case lastRewardDate
    }
}

// MARK: - Int value
extension AppPreferences: IntDefaults {
    
    enum IntKey: String {
        /// 前回報酬付与時のアプリ利用期間enumのraw value
        case lastAppUsagePeriodRewardRawValue
    }
}
