//
//  ContentView.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        
        // 로그인이 되어있지 않은 상태면 로그인 뷰로,
        if viewModel.userSession == nil {
            LoginView(appleLoginViewModel: AppleLoginViewModel())
        } else {
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
                    .tag(2)
                
            }
        }
    }
}

#Preview {
    ContentView()
}
