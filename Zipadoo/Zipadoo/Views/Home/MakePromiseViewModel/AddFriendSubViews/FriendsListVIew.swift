//
//  FriendsListVIew.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/25.
//

import SwiftUI

struct FriendsListVIew: View {
    
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    
    @Binding var isShowingSheet: Bool
    @Binding var selectedFriends: [User]
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // 더미데이터
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        NavigationStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.secondary)
                .frame(width: 360, height: 120)
                .overlay {
                    VStack {
                        HStack {
                            if selectedFriends.isEmpty {
                                Text("목록에서 초대할 친구를 선택해주세요")
                            } else {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(selectedFriends) { friend in
                                            FriendSellView(selectedFriends: $selectedFriends, friend: friend)
                                                .padding()
                                                .padding(.trailing, -50)
                                        }
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                }
                                .frame(height: 90)
                                .scrollIndicators(.hidden)
                            }
                        }
                    }
                }
            // MARK: 친구목록
            List(friendsStore.friendsFetchArray) { friend in
                Button {
                    // 친구를 선택하면 seledtedFriends에 추가
                    if !selectedFriends.contains(friend) {
                        selectedFriends.append(friend)
                    } else {
                        showAlert = true
                        alertMessage = "\(friend.nickName)님은 이미 존재합니다."
                    }
                } label: {
                    // 친구 추가 목록에 넣은 친구는 opacity 처리하여 구분 쉽게 함
                    HStack {
                        if !selectedFriends.contains(friend) {
                            ProfileImageView(imageString: friend.profileImageString, size: .mini)
                            Text(friend.nickName)
                        } else {
                                ProfileImageView(imageString: friend.profileImageString, size: .mini)
                                .opacity(0.5)
                                Text(friend.nickName)
                                .foregroundColor(.secondary)
                               
                            }
                        
                        
                    
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인")) {
                        }
                    )
                }
            }
            .listStyle(.plain)
            .navigationTitle("친구 목록")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    try await friendsStore.fetchFriends()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("완료")
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsListVIew(isShowingSheet: .constant(true), selectedFriends: .constant([dummyUser]))
}
