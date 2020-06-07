//
//  KeyNamespaceable.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

protocol KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    
    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(String(describing: type(of: key))).\(key.rawValue)"
    }
}
