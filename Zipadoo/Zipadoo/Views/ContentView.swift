//
//  ContentView.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            // 홈
            HomeMainView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
                .tag(0)
            
            // 친구리스트
            FriendsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("친구")
                }
                .tag(1)
            
            // 마이페이지
            MyPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이")
                }
                .tag(1)
        }
    }
}

#Preview {
    ContentView()
}
