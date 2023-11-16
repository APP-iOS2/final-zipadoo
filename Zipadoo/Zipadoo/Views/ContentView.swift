//
//  ContentView.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var alertStore: AlertStore
    @EnvironmentObject var widgetStore: WidgetStore
    @EnvironmentObject var promiseViewModel: PromiseViewModel
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    
    @StateObject var viewModel = ContentViewModel()
    @Binding var selectedTab: Int
    
    var body: some View {
        // 로그인이 되어있지 않은 상태면 로그인 뷰로,
        if viewModel.userSession?.uid == nil {
            LoginView()
        } else {
            TabView(selection: $selectedTab) {
                // MARK: - 홈 뷰
                HomeMainView(user: viewModel.currentUser)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("홈")
                    }
                    .tag(0)
                    .environmentObject(alertStore)
                    .environmentObject(promiseViewModel)
                    .environmentObject(widgetStore)
                
                // MARK: - 친구리스트 뷰
                FriendsView(friendsStore: friendsStore)
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("친구")
                    }
                    .tag(1)
                    .badge(friendsStore.requestFetchArray.count)
                
                // MARK: - 마이페이지 뷰
                MyPageView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("마이")
                    }
                    .tag(2)
                    .environmentObject(promiseViewModel)
            }
            .arrivalMessageAlert(isPresented: $alertStore.isPresentedArrival, arrival: alertStore.arrivalMsgAlert)
            .onAppear {
                Task {
                    try await friendsStore.fetchFriendsRequest()
                }
            }
        }
    }
}

#Preview {
    ContentView(selectedTab: .constant(0))
        .environmentObject(AlertStore())
        .environmentObject(PromiseViewModel())
}
