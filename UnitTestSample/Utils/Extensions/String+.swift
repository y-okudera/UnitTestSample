//
//  String+.swift
//  UnitTestSample
//
//  Created by okudera on 2020/06/06.
//  Copyright © 2020 yuoku. All rights reserved.
//

import Foundation

extension String {

    func toDate(with format: String) -> Date? {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar.gregorianJST()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
