//
//  AccountView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI

// 이메일로 가입되어 있는 사람만 정보 수정 뷰 뜰 것
struct AccountView: View {
    
    @ObservedObject var viewModel = EditProfileViewModel()
    
    @Environment (\.dismiss) private var dismiss
    
    @State var isEditAlert: Bool = false
    @State var isPromaryAlert: Bool = false
    
    /// 비밀번호를 동일하게 썼다면 true
    var isCorrectPassword: Bool {
        viewModel.password == viewModel.passwordCheck
    }
    
    // 알람 메세지
    var alertMessage: String {
        if viewModel.nickname.isEmpty || viewModel.phoneNumber.isEmpty ||
            viewModel.password.isEmpty ||
            viewModel.passwordCheck.isEmpty {
            "정보를 채워주세요"
            
        } else {
            viewModel.password == viewModel.passwordCheck ? "회원정보가 수정됩니다" : "비밀번호를 다시 확인해주세요"
        }
    }
    
    var secondaryButtonText: String {
        viewModel.password == viewModel.passwordCheck ? "수정" : "확인"
    }
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                // 이미지 피커 예정
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .clipShape(Circle())
//                    .overlay(Circle())
//                    .opacity(0.4)
            }
            .frame(width: UIScreen.main.bounds.size.width, height: 200)
            .background(.gray)
            
            VStack(alignment: .leading) {
                
                textFieldCell("새로운 닉네임", text: $viewModel.nickname)
                    .padding(.bottom)
                
                textFieldCell("새로운 연락처", text: $viewModel.phoneNumber)
                    .padding(.bottom)
                
                secureTextFieldCell("새로운 비밀번호", text: $viewModel.password)
                    .padding(.bottom)
                
                secureTextFieldCell("비밀번호 확인", text: $viewModel.passwordCheck)
                if isCorrectPassword {
                    Text("비밀번호가 일치합니다")
                        .foregroundStyle(.green)
                        .font(.footnote)
                } else {
                    Text("비밀번호가 일치하지 않습니다")
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
                
            }
            .padding()
            
            Spacer()
            
        }
        .navigationTitle("회원정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: { isEditAlert.toggle() }, label: {
                    Text("수정")
                })
            }
        }
        .alert(isPresented: $isEditAlert) {
            Alert(
                title: Text(""),
                message: Text(alertMessage),
                
                primaryButton: .default(Text("취소"), action: {
                    isEditAlert = false
                }),
                secondaryButton: .destructive(Text(secondaryButtonText), action: {
                    isEditAlert = false
                    dismiss()
                
                })
            )
        }
    }
    
    private func textFieldCell(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                
            TextField("", text: text)
                .textFieldStyle(.roundedBorder)
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
    NavigationStack {
        AccountView()
    }
}
