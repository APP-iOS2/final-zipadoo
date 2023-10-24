//
//  FriendsView.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/21.
//

import SwiftUI
import SlidingTabView

struct FriendsView: View {
    
    @StateObject var friendsStore: FriendsStore
    /// 친구 삭제 알람
    @State private var isDeleteAlert: Bool = false
    /// segmentedControl 인덱스
    @State private var selectedSegmentIndex: Int = 0
    /// 삭제버튼 눌렸을 때 선택된 친구
    @State private var selectedFriendId: String = ""
    /// 상단 탭바 인덱스
    @State private var tabIndex = 0
    /// 친구 추가뷰 시트
    @State private var isShowingFriendsRegistrationView = false
  
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
            }
            .fontWeight(.semibold)
            //            .pickerStyle(SegmentedPickerStyle())
            .navigationTitle("친구 관리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingFriendsRegistrationView = true
                    } label: {
                        Image(systemName:"person.crop.circle.fill.badge.plus")
                    }
                    .foregroundColor(.primary)
                    .sheet(isPresented: $isShowingFriendsRegistrationView) {
                        FriendsRegistrationView(friendsStore: friendsStore)
                            .presentationDetents([.fraction(0.2)])
                            .presentationDragIndicator(.hidden)
      
                    }
                }
                // MARK: - 지파두 마크
                ToolbarItem(placement: .topBarLeading) {
                    Image("zipadooMark")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
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
            .onAppear {
                Task {
                    try await friendsStore.fetchFriendsRequest()
                }
            }
        }
    }
    
    // MARK: - 친구 목록 뷰
    private var friendListView: some View {
        VStack {
            // 패치가 끝났다면
            if friendsStore.isLoadingFriends == false {
                if friendsStore.friendsFetchArray.isEmpty {
                    VStack {
                        //텍스트만 나오도록 제거
//                        Image(systemName: "person.fill.xmark")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 40, height: 40)
                        Group {
                            Text("아직 친구가 없어요")
                            Text("친구를 추가해 보세요!")
                        }
                        .font(.title3)
                    }
                    .foregroundColor(.secondary)
                    
                } else {
                    List {
                        ForEach(friendsStore.friendsFetchArray) { friend in
                            ZStack {
                                NavigationLink(destination: FriendProfileView(user: friend), label: {
                                    // 리스트에 네비게이션 링크 적용시 ">" 마크 제거하기 위하여 ZStack, EmptyView(), Opacatiy(0) 사용
                                    EmptyView()
                                })
                                .opacity(0)
                                
                                HStack {
                                    // 프로필 이미지
                                    ProfileImageView(imageString: friend.profileImageString, size: .mini)
                                    
                                    // 이름, 닉네임
                                    VStack(alignment: .leading) {
                                        Text(friend.nickName)
                                            .fontWeight(.semibold)
                                            .font(.headline)
                                        //                                            Text(FriendProfileView.user.crustDepth)
                                        // Text(friend.tardyTitle)
                                        Text("뉴비약속러")
                                            .foregroundStyle(Color.secondary)
                                            .font(.caption)
                                    }
                                    Spacer()
                                    
                                } // Hstack
                                
                            } // Foreach
                            .swipeActions {
                                Button {
                                    selectedFriendId = friend.id
                                    isDeleteAlert.toggle()
                                    Task {
                                        try await friendsStore.fetchFriends()
                                    }
                                }label: {
                                    //                                        Image(systemName: "trash.fill")
                                    Text("삭제")
                                        .fontWeight(.semibold)
                                }
                                .tint(.red)
                            } // swipe

                        } // Zstack
                    } // List
                    .listStyle(.plain)
                    .padding(.top, -17)
                    
                }
            }
        }
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
        VStack {
            // 패치가 끝났다면
            if friendsStore.isLoadingRequest == false {
                if friendsStore.requestFetchArray.isEmpty {
                    Text("받은 친구 요청이 없어요!")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    
                } else {
                    List {
                        ForEach(friendsStore.requestFetchArray) { friend in
                            ZStack {
                                NavigationLink(destination: FriendProfileView(user: friend), label: {
                                    HStack {
                                        // 프로필 이미지
                                        ProfileImageView(imageString: friend.profileImageString, size: .mini)
                                        
                                        // 이름, 닉네임
                                        VStack(alignment: .leading) {
                                            Text(friend.nickName)
                                                .fontWeight(.semibold)
                                                .font(.headline)
                                            //                                            Text(FriendProfileView.user.crustDepth)
                                            // Text(friend.tardyTitle)
                                            Text("뉴비약속러")
                                                .foregroundStyle(Color.secondary)
                                                .font(.caption)
                                        }
                                        
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
                            
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, -17)
                }
            }
        }
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
        FriendsView(friendsStore: FriendsStore())
    }
}
