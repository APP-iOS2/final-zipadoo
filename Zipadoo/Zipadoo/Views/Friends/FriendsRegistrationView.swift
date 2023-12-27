//
//  FriendsRegistrationView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct FriendsRegistrationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var friendsStore: FriendsStore
    /// 친구 닉네임
    @State private var nickNameTextField: String = ""
    /// 알람 노출유무
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                HStack {
                    TextField("친구의 닉네임을 입력해주세요.", text: $nickNameTextField)
                        .padding(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                    
                    Button {
                        nickNameTextField = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .padding(.trailing, 10)
                            .foregroundColor(.secondary)
                    }
                } // HStack
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary)
                )
                
                HStack {
                    // 조건에 안맞을 시 알림메세지
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
                        Text("친구 요청")
                    }
                    .padding(.all, 10)
                    .background(Color.primary)
                    .cornerRadius(16)
                    .foregroundColor(.primaryInvert)
                    .font(Font.body.bold())
                } // HStack
            } // HStack
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
            if !friendsStore.alertMessage.isEmpty {
                Text("\(friendsStore.alertMessage)")
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        } // VStack
        .padding()
    } // body
} // struct

#Preview {
    NavigationStack {
        FriendsRegistrationView(friendsStore: FriendsStore())
    }
}
