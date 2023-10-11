//
//  FriendsListVIew.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/25.
//

import SwiftUI

struct FriendsListVIew: View {
    
    let loginUser: UserStore
    
    // 현재 로그인한 유저의 데이터
    //    @StateObject private var loginUser: UserStore = UserStore()
    
    // 로그인한 유저의 친구 ID 리스트
    @State private var loginUserFriendsListID: [String] = []
    
    // 유저가 선택한 친구 ID 리스트
    @State private var chooseLoginUserFriendsListID = []
    
    @Binding var isShowingSheet: Bool
    @Binding var selectedFriends: [String]
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // 더미데이터
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        NavigationStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
                .frame(width: 360, height: 120)
                .overlay {
                    VStack {
                        HStack {
                            if selectedFriends.isEmpty {
                                Text("목록에서 초대할 친구를 선택해주세요")
                            } else {
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(selectedFriends, id: \.self) { name in
                                            FriendSellView(name: name, selectedFriends: $selectedFriends).padding()
                                                .padding(.trailing, -50)
                                        }
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                }
                                .frame(height: 90)
                                .scrollIndicators(.hidden)
                            }
                        } // HStack
                    } // VStack
                } // overlay
            if loginUserFriendsListID.isEmpty {
                Text("저런...친구가 없군요...")
            } else {
                
            }
            List(friends, id: \.self) { friend in
                HStack {
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                        .font(.title3)
                    Text(friend)
                        .onTapGesture {
                            if !selectedFriends.contains(friend) {
                                selectedFriends.append(friend)
                            } else {
                                showAlert = true
                                alertMessage = "\(friend)님은 이미 존재합니다."
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
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("완료")
                    }
                }
            }
            .onAppear {
                if let userID = AuthStore.shared.currentUser?.id {
                    loginUser.fetchLoginUserFriendsID(userID, loginUserFriendsListID)
//                    { friendsIdArray in
//                        if let friendsIdArray = friendsIdArray {
//                            loginUserFriendsListID = friendsIdArray
//                            print(loginUserFriendsListID)
//                        }
//                    }
                }
            }
        } // NavigationStack
    }
}

#Preview {
    FriendsListVIew(loginUser: UserStore(), isShowingSheet: .constant(true), selectedFriends: .constant([""]))
}
