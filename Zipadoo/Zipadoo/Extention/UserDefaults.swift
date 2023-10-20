//
//  UserDefaults.swift
//  Zipadoo
//
//  Created by 아라 on 10/4/23.
//

import Foundation

/// UserDefaults의 Extension
extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.education.techit.zipadoo.dev"
        return UserDefaults(suiteName: appGroupId)!
    }
}
