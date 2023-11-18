//
//  EditPasswordView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/04.
//

import SwiftUI

// 사용자 비밀번호 변경을 위한 뷰
struct EditPasswordView: View {
    @ObservedObject var userStore = UserStore()
    @Environment (\.dismiss) private var dismiss
    
    @State private var newpassword: String = ""
    @State private var newpasswordCheck: String = ""
    @State private var isEditAlert: Bool = false
    
    /// 비밀번호확인이 다르다면 true
    private var isPasswordDifferent: Bool {
        newpassword != newpasswordCheck
    }
    
    /// 비어있는 TextField가 있을 때 true
    private var isValid: Bool {
        isCorrectPassword(password: newpassword)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            secureTextFieldCell("새로운 비밀번호", text: $newpassword)
                .padding(.bottom)
            
            secureTextFieldCell("비밀번호 확인", text: $newpasswordCheck)
            
            if isPasswordDifferent && !newpasswordCheck.isEmpty {
                Text("비밀번호가 일치하지 않습니다")
                    .foregroundStyle(.red)
                    .font(.footnote)
            } else if !newpasswordCheck.isEmpty {
                Text("비밀번호가 일치합니다")
                    .foregroundStyle(.green)
                    .font(.footnote)
            }
            Spacer()
        }
        .padding()
        .navigationTitle("비밀번호 변경")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isEditAlert.toggle() }, label: {
                    Text("수정")
                })
                .disabled(isPasswordDifferent || !isValid)
            }
        }
        .alert(isPresented: $isEditAlert) {
            Alert(
                title: Text(""),
                message: Text("회원정보가 수정됩니다"),
                primaryButton: .default(Text("취소"), action: {
                    isEditAlert = false
                }),
                secondaryButton: .destructive(Text("수정"), action: {
                    isEditAlert = false
                    dismiss()
                    Task {
                        try await userStore.updatePassword(newValue: newpassword)
                    }
                })
            )
        }
    }
    
    private func secureTextFieldCell(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            SecureField("6~20자 사이로 입력해주세요", text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    EditPasswordView()
}
