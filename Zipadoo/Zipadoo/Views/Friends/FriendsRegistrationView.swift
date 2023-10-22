//
//  FriendsRegistrationView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct FriendsRegistrationView: View {
    
    @ObservedObject var friendsStore: FriendsStore
    @Environment(\.dismiss) private var dismiss
    
    /// 친구 닉네임
    @State private var nickNameTextField: String = ""
    /// 알람 노출유무
    @State private var isShowingAlert: Bool = false
    /*
    /// 친구 연락처
    @State private var phoneTextField: String = ""
    */
    
    var body: some View {
        VStack(alignment: .leading) {
            TextField("친구의 닉네임을 입력해주세요.", text: $nickNameTextField)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary)
                )
                .padding(.bottom, 5)
            
            // 해당하는 닉네임이 없으면 알람메세지
            if !friendsStore.alertMessage.isEmpty {
                Text("\(friendsStore.alertMessage)")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 추가성공 -> dismiss
                    // 추가실패 -> 현 페이지 머물기, 그런 사람 없다고 밑에 안내문구
                    Task {
                        try await friendsStore.findFriend(friendNickname: nickNameTextField) { resultBool in
                            if resultBool { // 추가할 수 있으면 알람
                                friendsStore.alertMessage = ""
                                isShowingAlert.toggle()
                                
                            }
                        }
                    }
                    
                } label: {
                    Text("추가")
                }
            }
        }
        .alert(isPresented: $isShowingAlert, content: {
            
            Alert(
                title: Text(""),
                message: Text("친구를 요청합니다"),
                dismissButton: .default(Text("확인"), action: {
                    isShowingAlert = false
                    dismiss()
                    friendsStore.alertMessage = ""
                })
            )
        })
        .onAppear {
            friendsStore.alertMessage = ""
        }
    }
}

#Preview {
    NavigationStack {
        FriendsRegistrationView(friendsStore: FriendsStore())
    }
}
