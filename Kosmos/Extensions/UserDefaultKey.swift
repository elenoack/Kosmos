//
//  UserDefaultKey.swift
//  Kosmos
//
//  Created by TMS on 13.11.2021.
//


import Foundation

struct UserDefaultKey: RawRepresentable {
    let rawValue: String
}

extension UserDefaultKey: ExpressibleByStringLiteral {
    init(stringLiteral value: String) {
        rawValue = value
    }
}
