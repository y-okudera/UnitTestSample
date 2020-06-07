//
//  AppDelegate.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 初回起動日時をUserDefaultsに保存
        if AppPreferences.shared.date(forKey: .firstLaunchingDate) == nil {
            AppPreferences.shared.set(value: Date(), forKey: .firstLaunchingDate)
        }
        return true
    }
}
