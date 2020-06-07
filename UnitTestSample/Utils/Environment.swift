//
//  Environment.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/07.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

final class Environment {

    static let shared = Environment()
    private init() {}
}

extension Environment {

    /// UnitTest実行中かどうか
    func isTesting() -> Bool {
        return ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
    }
}
