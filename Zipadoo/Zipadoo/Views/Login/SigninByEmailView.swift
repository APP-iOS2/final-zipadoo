//
//  SigninByEmailView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/26.
//

import SwiftUI

struct SigninByEmailView: View {
    
    @ObservedObject var emailLoginStore: EmailLoginStore
    
    // 비밀번호 보이기
    @State private var isPasswordVisible = false
    /// 형식 유효메세지
    @State private var validMessage = " "
    /// 닉네임 중복여부
    @State private var isOverlapNickname = false
    /// 닉네임 중복 유효메세지 노출유무
    @State private var isPresentedMessage = false
    /// 닉네임 중복 유효메세지
    @State private var nicknameOverlapMessage = ""
    /// 닉네임 중복 유효 메세지 글자색
    @State private var nicknameMessageColor: Color = .black
    /// 조건에 맞으면 true, 다음페이지로 넘어가기
    @State private var readyToNavigate: Bool = false
    
    /// 모든 형식이 유효한지
    private var isValid: Bool {
        isCorrectNickname(nickname: emailLoginStore.nickName) && isCorrectPhoneNumber(phonenumber: emailLoginStore.phoneNumber) && isCorrectPassword(password: emailLoginStore.password)
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
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                
                Spacer()
                    .frame(height: 50)
                
                // MARK: - 입력 안내 메세지
                Text("계정이 없습니다. \n가입할 이름과 휴대폰 번호를 입력해 주세요.")
                    .foregroundColor(.primary)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Text("\(validMessage)")
                    .font(.subheadline)
                    .foregroundStyle(.red.opacity(0.7))
                
                // MARK: - 이름 입력
                Group {
                    HStack {
                        TextField("닉네임", text: $emailLoginStore.nickName)
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
                        .foregroundColor(Color.primary.opacity(0.4))
                    } // HStack
                    
                    Rectangle()
                        .frame(height: 1)
                        .foregroundStyle(Color.secondary)
                        .padding(.bottom, 5)
                    
                    Text("2~6자로 입력해주세요. 프로필 수정에서 변경 가능합니다.")
                        .font(.subheadline)
                        .foregroundStyle(Color.primary.opacity(0.7))
                    
                    if isPresentedMessage {
                        Text(nicknameOverlapMessage)
                            .font(.subheadline)
                            .foregroundStyle(nicknameMessageColor.opacity(0.7))
                    }
                } // 이름 입력 Group
                
                // MARK: - 휴대폰 번호 입력
                // 휴대폰 번호 입력 칸
                Spacer()
                    .frame(height: 20) // 공간용
                
                Group {
                    HStack {
                        TextField("휴대폰 번호", text: $emailLoginStore.phoneNumber)
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
                        .foregroundColor(Color.primary.opacity(0.4))
                    } // HStack
                    
                    // 텍스트필드 줄
                    Rectangle().frame(height: 1)
                        .foregroundStyle(Color.secondary)
                        .padding(.bottom, 5)
                    
                    Text("-를 제외하고 입력해주세요")
                        .font(.subheadline)
                        .foregroundStyle(Color.primary.opacity(0.7))
                } // 휴대폰 입력 Group
                
                Spacer()
                    .frame(height: 20)
                // MARK: - 비밀번호 입력
                Group {
                    HStack {
                        SecureField("비밀번호", text: $emailLoginStore.password)
                            .opacity(0.9)
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
                        .foregroundColor(Color.primary.opacity(0.4))
                    }
                    
                    Rectangle().frame(height: 1)
                        .foregroundStyle(Color.secondary)
                        .padding(.bottom, 5)
                    
                    // 하단 안내 문구
                    HStack {
                        Text("6자리 이상 입력해주세요.")
                            .font(.subheadline)
                            .foregroundStyle(Color.primary.opacity(0.7))
                    }
                    
                    Spacer()
                } // 비밀번호 Group
            } // VStack
            .padding([.leading, .trailing])
            // MARK: - 상단 다음 넘어가기 버튼
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
            } // toolbar
            .navigationDestination(isPresented: $readyToNavigate) {
                SigninByEmail2View(emailLoginStore: emailLoginStore)
            }
        } // ZStack
    } // body
} // struct

#Preview {
    NavigationStack {
        SigninByEmailView(emailLoginStore: EmailLoginStore())
    }
}
