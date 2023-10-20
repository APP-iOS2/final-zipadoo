//
//  AppleSignInView.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/18/23.
//

import SwiftUI

struct AppleSignInView: View {
    @ObservedObject var signInViewModel: AppleSigninViewModel
    
    @State private var isPasswordVisible = false // 비밀번호 보이기
    
    /// 형식 유효메세지
    @State private var validMessage = " "
    /// 닉네임 중복 유효메세지 노출유무
    @State private var isPresentedMessage = false
    /// 닉네임 중복 유효메세지
    @State private var nicknameOverlapMessage = ""
    /// 닉네임 중복 유효 메세지 글자색
    @State private var nicknameMessageColor: Color = .black
    /// 닉네임 중복여부
    @State private var isOverlapNickname = false
    /// 모든 형식이 유효한지
    private var isValid: Bool {
        isCorrectNickname(nickname: signInViewModel.nickName) && isCorrectPhoneNumber(phonenumber: signInViewModel.phoneNumber)
    }
    /// 조건에 맞으면 true, 다음페이지로 넘어가기
    @State private var readyToNavigate: Bool = false
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Spacer().frame(height: 50) // Spacer() 공간
                // MARK: - 입력 안내 메세지
                Text("계정이 없습니다. \n가입할 이름과 휴대폰 번호를 입력해 주세요.")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(validMessage)")
                    .font(.subheadline)
                    .foregroundStyle(.red.opacity(0.7))
                
                Group {
                    // MARK: - 이름 입력
                    HStack {
                        TextField("닉네임", text: $signInViewModel.nickName, prompt: Text("닉네임").foregroundColor(.secondary.opacity(0.7)))
                            .foregroundColor(Color.primary)
                            .opacity(0.9)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .autocapitalization(.none)
                            .frame(height: 35)
                        
                        // 입력한 내용 지우기 버튼
                        Button {
                            signInViewModel.nickName = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                        .foregroundColor(Color.primary.opacity(0.4))
                    }
                    Rectangle().frame(height: 1)
                        .foregroundStyle(Color.secondary)
                        .padding(.bottom, 5)
                    
                    // MARK: - 이름 하단 안내 문구
                    HStack {
                        Text("2~6자로 입력해주세요. 프로필 수정에서 변경 가능합니다.")
                            .font(.subheadline)
                            .foregroundStyle(Color.primary.opacity(0.7))
                        Spacer()
                    }
                    
                    if isPresentedMessage {
                        HStack {
                            Text(nicknameOverlapMessage)
                                .font(.subheadline)
                                .foregroundStyle(nicknameMessageColor.opacity(0.7))
                            Spacer()
                        }
                    }
                    // MARK: - 휴대폰 번호 입력
                    // 휴대폰 번호 입력 칸
                    Spacer()
                        .frame(height: 20) // 공간용
                    
                    Group {
                        HStack {
                            TextField("휴대폰 번호", text: $signInViewModel.phoneNumber, prompt: Text("휴대폰 번호").foregroundColor(.secondary.opacity(0.7)))
                                .foregroundColor(Color.primary)
                                .opacity(0.9)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                                .keyboardType(.numberPad)
                            
                            // 입력한 내용 지우기 버튼
                            Button {
                                signInViewModel.phoneNumber = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                            .foregroundColor(Color.primary.opacity(0.4))
                        }
                        
                        // 텍스트필드 줄
                        Rectangle().frame(height: 1)
                            .foregroundStyle(Color.secondary)
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("-를 제외하고 입력해주세요")
                                .font(.subheadline)
                                .foregroundStyle(Color.primary.opacity(0.7))
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)// 공간용
                    // MARK: - 비밀번호 입력
                    //                    Group {
                    //                        HStack {
                    //                            SecureField("비밀번호", text: $emailLoginStore.password, prompt: Text("비밀번호").foregroundColor(.secondary.opacity(0.7)))
                    //                                .foregroundColor(Color.primary)
                    //                                .opacity(0.9)
                    //                                .font(.title3)
                    //                                .fontWeight(.semibold)
                    //                                .autocapitalization(.none)
                    //                                .frame(height: 35)
                    //                            // 입력한 내용 지우기 버튼
                    //                            Button {
                    //                                emailLoginStore.password = ""
                    //                            } label: {
                    //                                Image(systemName: "x.circle.fill")
                    //                            }
                    //                            .foregroundColor(Color.primary.opacity(0.4))
                    //                        }
                    //
                    //                        Rectangle().frame(height: 1)
                    //                            .foregroundStyle(Color.secondary)
                    //                            .padding(.bottom, 5)
                    //
                    //                        // 하단 안내 문구
                    //                        HStack {
                    //                            Text("6자리 이상 입력해주세요.")
                    //                                .font(.subheadline)
                    //                                .foregroundStyle(Color.primary.opacity(0.7))
                    //                        }
                    //
                    //                        Spacer()
                    //
                    //                    } // 비밀번호 Group
                    Spacer()
                } // 모든 입력 Group
                //                .background(Color.primary)
            }
            .padding([.leading, .trailing])
            // MARK: - 상단 다음 넘어가기 버튼
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        checkValid()
                        Task {
                            try do
                        }
                    } label: {
                        Text("다음")
                            .fontWeight(.semibold)
                            .padding(.trailing, 5)
                            .font(.headline)
                    }
                }
            }
            .navigationDestination(isPresented: $readyToNavigate) {
                AppleSignInProfileView(signinViewModel: AppleSigninViewModel())
            }
        }
    }
    
    /// 유효성 검사
    func checkValid() {
        // 파베 중복확인 : 중복시 true
        Task {
            signInViewModel.nicknameCheck { overlap in
                isOverlapNickname = overlap
                
                if isValid && !isOverlapNickname {
                    // 닉네임중복X,형식에 모두 알맞게 썼다면 다음으로 넘어가기
                    readyToNavigate.toggle()
                    validMessage = " "
                    nicknameMessageColor = .green
                    nicknameOverlapMessage = "사용가능한 닉네임입니다"
                    isPresentedMessage = true
                    
                } else {
                    if isOverlapNickname {
                        // 닉네임 중복이라면
                        nicknameMessageColor = .red
                        nicknameOverlapMessage = "이미 존재하는 닉네임입니다"
                        isPresentedMessage = true
                    } else if isCorrectNickname(nickname: signInViewModel.nickName) {
                        nicknameMessageColor = .green
                        nicknameOverlapMessage = "사용가능한 닉네임입니다"
                        isPresentedMessage = true
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

//#Preview {
//    NavigationStack {
//        AppleSignInView(signInViewModel: AppleSigninViewModel())
//    }
//}
