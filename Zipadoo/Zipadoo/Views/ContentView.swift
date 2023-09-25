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
            Text("친구리스트 뷰")
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("친구")
                }
                .tag(1)
            
            // 마이페이지
            Text("마이페이지 뷰")
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이")
                }
                .tag(1)
        }
        .navigationBarBackButtonHidden(true) // 로그인 하고 back버튼이 보여서 숨김 목적
    }
}

#Preview {
    ContentView()
}
