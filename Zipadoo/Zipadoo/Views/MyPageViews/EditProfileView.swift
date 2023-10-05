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
    // 닉네임과 전화번호 유효성 검사
    private var isValid: Bool {
        isCorrectNickname(nickname: viewModel.nickname) && isCorrectPhoneNumber(phonenumber: viewModel.phoneNumber)
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
                    textFieldCell("새로운 닉네임", validMessage: "2~6자로 작성해주세요", text: $viewModel.nickname)
                        .padding(.bottom)

                    textFieldCell("새로운 연락처", validMessage: "- 를 제외하고 작성해주세요", text: $viewModel.phoneNumber)
                        .padding(.bottom)

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
                    .disabled(!isValid) // 필드가 하나라도 비어있거나 유효성검사 실패시 비활성화
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
                        }
                    })
                )
            }
        }
    }

    private func textFieldCell(_ title: String, validMessage: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
          
            Text(title)
            Text(validMessage)
                .font(.footnote)
                .foregroundColor(.gray)
                
            TextField("", text: text)
                .textFieldStyle(.roundedBorder)
        }
    }
}
#Preview {
    NavigationStack {
        EditProfileView()
    }
}
