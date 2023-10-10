//
//  SigninByEmailView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/26.
//

import SwiftUI

struct SigninByEmailView: View {
    @ObservedObject var emailLoginStore: EmailLoginStore
    
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
        isCorrectNickname(nickname: emailLoginStore.nickName) && isCorrectPhoneNumber(phonenumber: emailLoginStore.phoneNumber) && isCorrectPassword(password: emailLoginStore.password)
    }
    /// 조건에 맞으면 true, 다음페이지로 넘어가기
    @State private var readyToNavigate: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all) // 배경색
            
            VStack(alignment: .leading) {
                
                Rectangle().frame(height: 50) // Spacer() 공간
                
                Text("계정이 없습니다. \n가입할 이름과 휴대폰 번호를 입력해 주세요.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(validMessage)")
                    .font(.subheadline)
                    .foregroundStyle(.red.opacity(0.7))
                
                Group {
                    // 이름 입력 칸
                    HStack {
                        TextField("닉네임", text: $emailLoginStore.nickName, prompt: Text("닉네임").foregroundColor(.gray))
                            .foregroundColor(Color.white)
                            .opacity(0.9)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .autocapitalization(.none)
                            .frame(height: 35)
                        
                        // 입력한 내용 지우기 버튼
                        Button {
                            emailLoginStore.nickName = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                    }
                    .foregroundColor(.white.opacity(0.4))
                    
                    Rectangle().frame(height: 1)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.bottom, 5)
                    
                    // 하단 안내 문구
                    HStack {
                        Text("2~6자로 입력해주세요. 프로필 수정에서 변경 가능합니다.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
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
                    // 휴대폰 번호 입력 칸
                    Spacer()
                        .frame(height: 20) // 공간용
                    
                    Group {
                        HStack {
                            TextField("휴대폰 번호", text: $emailLoginStore.phoneNumber, prompt: Text("휴대폰 번호").foregroundColor(.gray))
                                .foregroundColor(Color.white)
                                .opacity(0.9)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                                .keyboardType(.numberPad)
                            
                            // 입력한 내용 지우기 버튼
                            Button {
                                emailLoginStore.phoneNumber = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                        }
                        .foregroundColor(.white.opacity(0.4))
                        
                        // 텍스트필드 줄
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("-를 제외하고 입력해주세요")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)// 공간용
                    
                    Group {
                        HStack {
                            SecureField("비밀번호", text: $emailLoginStore.password, prompt: Text("비밀번호").foregroundColor(.gray))
                                .foregroundColor(Color.white.opacity(0.3))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                            
                            // 입력한 내용 지우기 버튼
                            Button {
                                emailLoginStore.password = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                        }
                        .foregroundColor(.white.opacity(0.4))
                        
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.bottom, 5)
                        
                        // 하단 안내 문구
                        HStack {
                            Text("6자리 이상 입력해주세요.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                        }
                        
                        Spacer()

                    }// Group 휴대폰번호 입력 창
                    Spacer()
                } // Group
                .background(Color.black)
            }
            .padding([.leading, .trailing])
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                       checkValid()
                        
                    } label: {
                        Text("다음")
                            .fontWeight(.semibold)
                            .padding(.trailing, 5)
                            .font(.headline)
                    }
                }
            }
            .navigationDestination(isPresented: $readyToNavigate) {
                SigninByEmail2View(emailLoginStore: emailLoginStore)
            }
        }
    }
    
    /// 유효성 검사
    func checkValid() {
        
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
     
                } else {
                    if isOverlapNickname {
                        // 닉네임 중복이라면
                        nicknameMessageColor = .red
                        nicknameOverlapMessage = "이미 존재하는 닉네임입니다"
                        isPresentedMessage = true
                    } else if isCorrectNickname(nickname: emailLoginStore.nickName) {
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
        
        /*
        if !isOverlapNickname && isGoNext {
           // 닉네임 중복하지않고 형식에 모두 맞으면 화면전환
            readyToNavigate.toggle()
            nickNameValidMessage = "2~6자로 입력해주세요. 프로필 수정에서 변경 가능합니다"
            phoneValidMessage = "-를 제외하고 입력해주세요"
            passwordValidMessage = "6자리 이상 입력해주세요"
            
        } else {
            if !isCorrectNickname(nickname: emailLoginStore.nickName) {

                nickNameValidMessage = "닉네임을 형식에 맞게 입력해주세요"
                
            } else if isOverlapNickname {
                // 닉네임중복
                nickNameValidMessage = "이미 있는 닉네임입니다"
            } else if !isCorrectPhoneNumber(phonenumber: emailLoginStore.phoneNumber) {
                phoneValidMessage = "휴대폰 번호를 형식에 맞게 입력해주세요"
            } else if !isCorrectPassword(password: emailLoginStore.password) {
                passwordValidMessage = "비밀번호를 형식에 맞게 입력해주세요"
            }
        }
         */
    }
}
#Preview {
    NavigationStack {
        SigninByEmailView(emailLoginStore: EmailLoginStore())
    }
}
