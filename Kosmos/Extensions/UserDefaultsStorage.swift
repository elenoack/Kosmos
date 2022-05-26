//
//  UserDefaultsStorage.swift
//  Kosmos
//
//  Created by TMS on 13.11.2021.
//


import Foundation

class UserDefaultsStorage {
    @StrongUserDefault(key: .level, defaultValue: 0)
    var level: Int
    
    @UserDefault(key: .namePlayer)
    var namePlayer: String?
    
    @PointsUserDefault(key: .points, defaultValue: 0)
    var points: Int
    
    @ListUserDefault(key: .list, defaultValue: [])
    var list: [String]
}

private extension UserDefaultKey {
    static let level: UserDefaultKey = "Level"
    static let namePlayer: UserDefaultKey = "NamePlayer"
    static let points: UserDefaultKey = "Points"
    static let list: UserDefaultKey = "list"
}
