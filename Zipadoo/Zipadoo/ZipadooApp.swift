//
//  ZipadooApp.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI

@main
struct ZipadooApp: App {
    var body: some Scene {
        WindowGroup {
            FriendsLocationView(
                friendsLocationMapViewModel: FriendsLocationMapViewModel(), isShowingFriendSheet: false
            )
        }
    }
}
