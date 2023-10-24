//
//  AccountView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI

// 이메일로 가입되어 있는 사람만 정보 수정 뷰 뜰 것
struct EditProfileView: View {
    
    //@ObservedObject var viewModel = EditProfileViewModel()
    @ObservedObject var userStore: UserStore = UserStore()
    @Environment (\.dismiss) private var dismiss
    
    @State private var nickname: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedImage: UIImage?
    /// 알람노출
    @State private var isEditAlert: Bool = false
    /// 이미지피커 노출
    @State private var isShowingImagePicker = false
    @State private var nickNameMessage = ""
    @State private var numberMessage = ""
    
    /// 비어있는 TextField가 있을 때 true
    private var isFieldEmpty: Bool {
        nickname.isEmpty || phoneNumber.isEmpty
    }
    
    private var isVaild: Bool {
        isCorrectNickname(nickname: nickname) && isCorrectPhoneNumber(phonenumber: phoneNumber)
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                // 이미지 피커
                Button {
                    isShowingImagePicker.toggle()
                } label: {
                    // 프로필 사진 선택할 경우 프로필 사진으로 표시, 아닐 경우 파이어베이스에 저장된 이미지 보이도록
                    
                    if let profileImage = selectedImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                    } else {
                        ProfileImageView(imageString: userStore.getUserProfileImage(), size: .medium)
                    }
                    
                }
                .sheet(isPresented: $isShowingImagePicker) {
                    ImagePicker(selectedImage: $selectedImage)
                        .ignoresSafeArea(.all)
                    
                }
                .frame(width: UIScreen.main.bounds.size.width, height: 200)
                .background(.gray)
                
                // TextField
                VStack(alignment: .leading) {
                    textFieldCell("새로운 닉네임", text: $nickname)
                        .padding(.bottom)
                        .onChange(of: nickname) { newValue in
                            let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                            if filtered != newValue {
                                nickNameMessage = "특수문자는 입력할 수 없습니다."
                            } else {
                                nickNameMessage = ""
                            }
                        }
                    
                    Text(nickNameMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, -15)
                        .padding(.bottom, 5)
                        
                    
                    textFieldCell("새로운 연락처", text: $phoneNumber)
                        .padding(.bottom)
                        .onChange(of: phoneNumber) { newValue in
                            let filtered = newValue.filter { $0.isNumber }
                            if filtered != newValue {
                                numberMessage = "숫자만 입력해주세요"
                            } else {
                                numberMessage = ""
                            }
                        }
                    
                    Text(numberMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.top, -15)
                        .padding(.bottom, 5)
                    
                }
                .padding()
                
                Spacer()
                
            }
            .navigationTitle("회원정보 수정")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                nickname = userStore.currentUser?.nickName ?? ""
                phoneNumber = userStore.currentUser?.phoneNumber ?? ""
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: { isEditAlert.toggle() }, label: {
                        Text("수정")
                    })
                    .disabled(isFieldEmpty || !isVaild) // 필드가 하나라도 비어있으면 비활성화
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
                            try await userStore.updateUserData(image: selectedImage ,nick: nickname ,phone: phoneNumber)
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
}
    
#Preview {
    NavigationStack {
        EditProfileView()
    }
}
