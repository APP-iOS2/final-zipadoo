//
//  FriendsView.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/21.
//

import SwiftUI
import SlidingTabView

struct FriendsView: View {
    
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    @EnvironmentObject var widgetStore: WidgetStore
    /// 친구 삭제 알람
    @State private var isDeleteAlert: Bool = false
    /// segmentedControl 인덱스
    @State private var selectedSegmentIndex: Int = 0
    /// 삭제버튼 눌렸을 때 선택된 친구
    @State private var selectedFriendId: String = ""
    /// 상단 탭바 인덱스
    @State private var tabIndex = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                // MARK: - 변경 SlidingTab
                SlidingTabView(selection: $tabIndex, tabs:
                                ["친구 목록", "요청 목록"], animation: .easeInOut,
                               activeAccentColor: .zipadoo, inactiveAccentColor: .zipadoo, selectionBarColor: .
                               zipadoo)
                Spacer()
                if tabIndex == 0 {
                    friendListView
                } else if tabIndex == 1 {
                    friendRequestView
                }
                Spacer()
                // MARK: - 기존 SegmentedPickerStyle
//                Picker("option", selection: $selectedSegmentIndex) {
//                    Text("친구 목록").tag(0)
//                    Text("요청 목록").tag(1)
//                }
//                .padding()
//                
//                VStack {
//                    switch selectedSegmentIndex {
//                    case 0:
//                        friendListView
//                    case 1:
//                        friendRequestView
//                    default:
//                        friendListView
//                    }
//                }
            }
//            .pickerStyle(SegmentedPickerStyle())
            .navigationTitle("친구 관리")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $widgetStore.isShowingDetailForWidget) {
                PromiseDetailView(promise: widgetStore.widgetPromise ??
                                  Promise(id: "", makingUserID: "", promiseTitle: "", promiseDate: 0.0, destination: "", address: "", latitude: 0.0, longitude: 0.0, participantIdArray: [""], checkDoublePromise: false, locationIdArray: [""]))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        FriendsRegistrationView(friendsStore: friendsStore)
                    } label: {
                        Label("Add", systemImage: "person.crop.circle.fill.badge.plus")
                    }
                }
            }
            .alert(isPresented: $isDeleteAlert) {
                Alert(
                    title: Text(""),
                    message: Text("친구목록에서 삭제됩니다"),
                    primaryButton: .default(Text("취소"), action: {
                        isDeleteAlert = false
                    }),
                    secondaryButton: .destructive(Text("삭제"), action: {
                        isDeleteAlert = false
                        Task {
                            try await friendsStore.removeFriend(friendId: selectedFriendId)
                        }
                    })
                )
            }
        }
    }
    
    // MARK: - 친구 목록 뷰
    private var friendListView: some View {
        List {
            if friendsStore.friendsFetchArray.isEmpty {
                HStack {
                    Spacer()
                    VStack {
                        Image(systemName: "person.fill.xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                        Group {
                            Text("아직 친구가 없어요")
                            Text("친구를 추가해 보세요!")
                        }
                        .font(.title3)
                        .foregroundColor(.gray)
                    }
                    Spacer()
                }
            } else {
                ForEach(friendsStore.friendsFetchArray) { friend in
                    ZStack {
                        NavigationLink(destination: FriendProfileView(user: friend), label: {
                            HStack {
                                ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
                                
                                Text(friend.nickName)
                            }
                        })
                        HStack {
                            Spacer()
                            
                            Text("삭제")
                                .padding(5)
                                .foregroundColor(.gray)
                                .background(.primary)
                                .colorInvert()
                                .onTapGesture {
                                    selectedFriendId = friend.id
                                    isDeleteAlert.toggle()
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                try await friendsStore.fetchFriends()
            }
        }
        .refreshable {
            Task {
                try await friendsStore.fetchFriends()
            }
        }
    }
    
    // MARK: - 요청목록 뷰
    private var friendRequestView: some View {
        List {
            if friendsStore.requestFetchArray.isEmpty {
                Text("받은 친구 요청이 없어요!")
            } else {
                ForEach(friendsStore.requestFetchArray) { friend in
                    ZStack {
                        NavigationLink(destination: MyPageView(), label: {
                            HStack {
                                ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
                                
                                Text(friend.nickName)
                            }
                        })
                        
                        HStack {
                            Spacer()
                            
                            Text("수락")
                                .padding(5)
                                .foregroundColor(.green)
                                .colorInvert()
                                .background(.primary)
                                .colorInvert()
                                .onTapGesture {
                                    selectedFriendId = friend.id
                                    Task {
                                        try await friendsStore.addFriend(friendId: selectedFriendId)
                                        try await friendsStore.removeRequest(friendId: selectedFriendId)
                                    }
                                }
                                .padding(.trailing, 4)
                            
                            Text("거절")
                                .padding(5)
                                .foregroundColor(.red)
                                .colorInvert()
                                .background(.primary)
                                .colorInvert()
                                .onTapGesture {
                                    // 거절
                                    Task {
                                        try await friendsStore.removeRequest(friendId: selectedFriendId)
                                    }
                                }
                        }
                    }
                    .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
                }
            }
        }
        .listStyle(.plain)
        .onAppear {
            Task {
                try await friendsStore.fetchFriendsRequest()
            }
        }
        .refreshable {
            Task {
                try await friendsStore.fetchFriendsRequest()
            }
        }
    }
}

#Preview {
    NavigationStack {
        FriendsView()
    }
}
