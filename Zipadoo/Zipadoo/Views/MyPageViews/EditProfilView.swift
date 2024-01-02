//
//  AccountView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI

// 이메일로 가입되어 있는 사용자만 회원 정보 수정 뷰를 표시
struct EditProfileView: View {
    // 유효성검사위해 뷰 선언
    private let loginEmailCheckView = LoginEmailCheckView()
    private let signinByEmailView = SigninByEmailView(emailLoginStore: EmailLoginStore())
    @ObservedObject var emailLoginStore: EmailLoginStore
    @StateObject var viewModel = ContentViewModel()
    /// 비밀번호 보이기
    @State private var isPasswordVisible = false
    /// 형식 유효메세지
    @State private var validMessage = " "
    /// 닉네임 중복여부
    @State private var isOverlapNickname = false
    /// 닉네임 중복 유효메세지 노출유무
    @State private var isPresentedMessage = false
    /// 회원탈퇴 알럿
    @State private var isDeleteUserDataAlert = false
    /// 닉네임 중복 유효메세지
    @State private var nicknameOverlapMessage = ""
    /// 닉네임 중복 유효 메세지 글자색
    @State private var nicknameMessageColor: Color = .black
    /// 조건에 맞으면 true, 다음페이지로 넘어가기
    @State private var readyToNavigate: Bool = false
   
    @ObservedObject var userStore: UserStore = UserStore()
    @Environment (\.dismiss) private var dismiss
    
    @State private var nickname: String = ""
    @State private var phoneNumber: String = ""
    @State private var selectedImage: UIImage?
    @State private var isEditAlert: Bool = false
    @State private var isShowingImagePicker = false
    @State private var nickNameMessage = ""
    @State private var numberMessage = ""
    
    /// 비어있는 TextField가 있을 때 true
    private var isFieldEmpty: Bool {
        nickname.isEmpty
    }
    
    private var isValid: Bool {
        loginEmailCheckView.isCorrectNickname(nickname: emailLoginStore.nickName)
    }
    
    var body: some View {
        VStack {
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
            
            VStack(alignment: .leading) {
                Group {
                    HStack {
                        loginTextFieldView($emailLoginStore.nickName, nickname, isvisible: true)
                        
                        // 입력한 내용 지우기 버튼
                        eraseButtonView($emailLoginStore.nickName)
                    }
                    .onChange(of: emailLoginStore.nickName) { newValue in
                        let filtered = newValue.filter { $0.isLetter || $0.isNumber }
                        nickNameMessage = filtered != newValue ? "특수문자는 입력할 수 없습니다." : ""
                    }
                    underLine()
                        .padding(.top, -15)
                    Text("2글자 이상, 6글자 이하로 입력해주세요.")
                        .foregroundColor(.gray)
                        .padding(.top, -25)
                    
                    VStack(alignment: .leading) {
                        Text(nickNameMessage)
                            .foregroundColor(.red)
                            .font(.subheadline)
                            .opacity(0.7)
                        
                        if isPresentedMessage {
                            Text(nicknameOverlapMessage)
                                .modifier(LoginMessageStyle(color: nicknameMessageColor))
                        }
                    }
                }
                .padding(.top, 20)
                
//                Group {
//                    HStack {
//                        loginTextFieldView($emailLoginStore.phoneNumber, phoneNumber, isvisible: true)
//                        
//                        // 입력한 내용 지우기 버튼
//                        eraseButtonView($emailLoginStore.phoneNumber)
//                    }
//                    .onChange(of: emailLoginStore.phoneNumber) { newValue in
//                        let filtered = newValue.filter { $0.isNumber }
//                        numberMessage = filtered != newValue ? "숫자만 입력해주세요" : ""
//                    }
//                    underLine()
//                    
//                    Text(numberMessage)
//                        .foregroundColor(.red)
//                        .font(.subheadline)
//                        .opacity(0.7)
//                }
//                .padding(.top, 20)
            }
            .padding()
            
            Spacer()
            
            Button {
                isDeleteUserDataAlert = true
            } label: {
                Text("회원 탈퇴")
                    .underline()
            }
            .tint(.red)
            .padding(.bottom, 10)
        }
        .navigationTitle("회원정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            nickname = userStore.currentUser?.nickName ?? ""
//            phoneNumber = userStore.currentUser?.phoneNumber ?? ""
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
//                    checkValid()
                    isEditAlert = true
                    print("수정 버튼 누르기")
                } label: {
                    Text("수정")
                }
                .disabled(nickname.isEmpty || !isValid) // 필드가 하나라도 비어있으면 비활성화
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
                        try await userStore.updateUserData(image: selectedImage, nick: emailLoginStore.nickName, phone: emailLoginStore.phoneNumber)
                    }
                })
            )
        }
        .alert(isPresented: $isDeleteUserDataAlert) {
            Alert(
                title: Text("정말로 회원 탈퇴 하시겠습니까?"),
                message: Text("회원 정보가 즉시 삭제됩니다"),
                primaryButton: .default(Text("취소"), action: {
                    isDeleteUserDataAlert = false
                }),
                secondaryButton: .destructive(Text("회원 탈퇴"), action: {
                    Task {
                        do {
                            try await AuthStore.shared.deleteAccount()
                        } catch {
                            print("회원 탈퇴 실패: \(error.localizedDescription)")
                        }
                    }
                })
            )
        }
    }
    
    private func textFieldCell(_ title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading) {
            Text(title)
            TextField("", text: text)
                .textFieldStyle(.roundedBorder)
                .autocapitalization(.none)
                .autocorrectionDisabled()
        }
    }
    private func checkValid() {
        // 파베 중복확인 : 중복시 true
        Task {
            emailLoginStore.nicknameCheck { overlap in
                isOverlapNickname = overlap
                
                if isValid && !isOverlapNickname {
                    // 닉네임중복X,형식에 모두 알맞게 썼다면 다음으로 넘어가기
                    readyToNavigate.toggle()
                    validMessage = " "
                    nicknameMessageColor = .green
                    nicknameOverlapMessage = "사용가능한 닉네임입니다"
                    isPresentedMessage = true
                    isEditAlert.toggle()
                } else {
                    if isOverlapNickname {
                        // 닉네임 중복이라면
                        nicknameMessageColor = .red
                        nicknameOverlapMessage = "이미 존재하는 닉네임입니다"
                        isPresentedMessage = true
                    } else if loginEmailCheckView.isCorrectNickname(nickname: emailLoginStore.nickName) {
                        nicknameMessageColor = .green
                        nicknameOverlapMessage = "사용가능한 닉네임입니다"
                        isPresentedMessage = true
                        isEditAlert.toggle()
                    } else {
                        nicknameOverlapMessage = ""
                        isPresentedMessage = false
                    }
                    if !isValid {
                        validMessage = "형식에 맞게 다시 입력해주세요"
                    } else {
                        validMessage = " "
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(emailLoginStore: EmailLoginStore())
    }
}
