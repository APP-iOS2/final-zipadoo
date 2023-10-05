//
//  EditPasswordView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/05.
//

import SwiftUI

/// 비밀번호 변경 뷰
struct EditPasswordView: View {

    @ObservedObject var viewModel = EditProfileViewModel()

    @Environment (\.dismiss) private var dismiss

    /// 알람노출
    @State private var isEditAlert: Bool = false

    /// 비밀번호확인이 다르다면 true
    private var isPasswordDifferent: Bool {
        viewModel.newpassword != viewModel.newpasswordCheck
    }

    /// 비어있는 TextField가 있을 때 true
    private var isFieldEmpty: Bool {
        viewModel.newpassword.isEmpty || viewModel.newpasswordCheck.isEmpty
    }

    var body: some View {
        VStack {
            secureTextFieldCell("새로운 비밀번호", text: $viewModel.newpassword)
                .padding(.bottom)

            secureTextFieldCell("비밀번호 확인", text: $viewModel.newpasswordCheck)

            // 비밀번호 확인 밑 문구
            if isPasswordDifferent && !viewModel.newpasswordCheck.isEmpty {
                Text("비밀번호가 일치하지 않습니다")
                    .foregroundStyle(.red)
                    .font(.footnote)
            } else if !viewModel.newpasswordCheck.isEmpty {
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
                .disabled(isPasswordDifferent || isFieldEmpty) // 비밀번호가 다르게 입력되거나 필드가 하나라도 비어있으면 비활성화
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
                        try await viewModel.updatePassword()
                    }
                })
            )
        }
    }

    private func secureTextFieldCell(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {

            Text(title)

            SecureField("", text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    EditPasswordView()
}
