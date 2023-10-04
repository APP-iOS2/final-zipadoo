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
            List(friends, id: \.self) { friend in
                HStack {
                    Image(systemName: "person.fill")
                    Text(friend)
                        .onTapGesture {
                            if !selectedFriends.contains(friend) {
                                if !selectedFriends.contains(friend) {
                                    selectedFriends.append(friend)
                                }
                                isShowingSheet = false
                            } else {
                                showAlert = true
                                alertMessage = "\(friend)님은 이미 존재합니다."
                            }
                            print(selectedFriends)
                        }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인")) {
                            isShowingSheet = false
                        }
                    )
                }
            }
            .navigationTitle("친구 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isShowingSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsListVIew(isShowingSheet: .constant(true), selectedFriends: .constant([""]))
}
