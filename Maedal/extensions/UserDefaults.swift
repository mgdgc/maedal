//
//  UserDefaults.swift
//  Maedal
//
//  Created by Peter Choi on 2021/01/29.
//

import Foundation

extension UserDefaults {
    static var shared: UserDefaults {
        return UserDefaults(suiteName: AppValue.appGroupId)!
    }
}
