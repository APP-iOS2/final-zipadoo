//
//  FriendsListVIew.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/25.
//

import SwiftUI

struct FriendsListVIew: View {
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
                        }
                    }
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
        }
    }
}

#Preview {
    FriendsListVIew(isShowingSheet: .constant(true), selectedFriends: .constant([""]))
}
