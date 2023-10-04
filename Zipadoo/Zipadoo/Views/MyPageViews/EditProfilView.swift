//
//  AccountView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI

// 이메일로 가입되어 있는 사람만 정보 수정 뷰 뜰 것
struct EditProfileView: View {
    
    @ObservedObject var viewModel = EditProfileViewModel()
    
    @Environment (\.dismiss) private var dismiss
    
    /// 알람노출
    @State private var isEditAlert: Bool = false
    /// 이미지피커 노출
    @State private var isShowingImagePicker = false
    
    /// 비밀번호확인이 다르다면 true
    private var isPasswordDifferent: Bool {
        viewModel.newpassword != viewModel.newpasswordCheck
    }
    
    /// 비어있는 TextField가 있을 때 true
    private var isFieldEmpty: Bool {
        viewModel.nickname.isEmpty || viewModel.phoneNumber.isEmpty || viewModel.newpassword.isEmpty || viewModel.newpasswordCheck.isEmpty
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                // 이미지 피커
                Button {
                    isShowingImagePicker.toggle()
                } label: {
                    // 프로필 사진 선택할 경우 프로필 사진으로 표시, 아닐 경우 파이어베이스에 저장된 이미지 보이도록
                    
                    if let profileImage = viewModel.selectedImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        ProfileImageView(imageString: viewModel.profileImageString, size: .medium)
                    }
                    
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $viewModel.selectedImage)
                        .ignoresSafeArea(.all)
                    
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 200)
                .background(.gray)
                
                // TextField
                VStack(alignment: .leading) {
                    textFieldCell("새로운 닉네임", text: $viewModel.nickname)
                        .padding(.bottom)
                    
                    textFieldCell("새로운 연락처", text: $viewModel.phoneNumber)
                        .padding(.bottom)
                    
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
                            try await viewModel.updateUserData()
                            _ = AuthStore.init()
                        }
                    })
                )
            }
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
        EditProfileView()
    }
}
