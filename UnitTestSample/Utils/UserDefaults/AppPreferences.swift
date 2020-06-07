//
//  AppPreferences.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

// MARK: - AppPreferences class
final class AppPreferences {

    static let shared = AppPreferences()

    fileprivate static let ud: UserDefaults = {
        // UnitTestの場合は、UserDefaultsの保存先をLibrary/Preferences/UT.plistにする
        if Environment.shared.isTesting() {
            let suiteName = "UT"
            UserDefaults().removePersistentDomain(forName: suiteName)
            return UserDefaults(suiteName: suiteName)!
        }
        else {
            return UserDefaults.standard
        }
    }()

    private init() {}
}

// MARK: - Date
protocol DateDefaults: KeyNamespaceable {
    associatedtype DateKey: RawRepresentable
}

extension DateDefaults where DateKey.RawValue == String {

    func set(value: Date?, forKey key: DateKey) {
        AppPreferences.ud.set(value, forKey: namespaced(key))
    }

    @discardableResult
    func date(forKey key: DateKey) -> Date? {
        return AppPreferences.ud.object(forKey: namespaced(key)) as? Date
    }

    func removeObject(forKey key: DateKey) {
        AppPreferences.ud.removeObject(forKey: namespaced(key))
    }
}

// MARK: - Int
protocol IntDefaults: KeyNamespaceable {
    associatedtype IntKey: RawRepresentable
}

extension IntDefaults where IntKey.RawValue == String {

    func set(value: Int?, forKey key: IntKey) {
        AppPreferences.ud.set(value, forKey: namespaced(key))
    }

    @discardableResult
    func int(forKey key: IntKey) -> Int {
        return AppPreferences.ud.integer(forKey: namespaced(key))
    }

    func removeObject(forKey key: IntKey) {
        AppPreferences.ud.removeObject(forKey: namespaced(key))
    }
}
