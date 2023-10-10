//
//  FriendsRegistrationView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct FriendsRegistrationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    /// 친구 닉네임
    @State private var nickNameTextField: String = ""
    /*
    /// 친구 연락처
    @State private var phoneTextField: String = ""
    */
    
    var body: some View {
        VStack {
            TextField("친구의 닉네임을 입력해주세요.", text: $nickNameTextField)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray)
                )
                .padding(.bottom, 5)
            /*
            TextField("친구의 연락처를 입력해주세요.", text: $phoneTextField)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray)
                )
            */
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 추가성공 -> dismiss
                    // 추가실패 -> 현 페이지 머물기, 그런 사람 없다고 밑에 안내문구
                } label: {
                    Text("추가")
                }
            }
        }
    }
}

#Preview {
    FriendsRegistrationView()
}
