//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginEmailCheckView: View {
    
    @ObservedObject private var emailLoginStore: EmailLoginStore = EmailLoginStore()
    
    // 이메일 중복 체크
    @State private var uniqueEmail: Bool = false
    // 유효성 확인 메세지
    @State private var validMessage: String = ""
    // uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    @State private var isSigninLinkActive: Bool = false
    // uniqueEmail = true일 경우 로그인뷰 버튼으로 활성화
    @State private var isLoginLinkActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(width: 50, height: 50)
            
            // MARK: - 상단 문구
            Text("이메일을 입력해 주세요.") // 상단 안내 문구
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("로그인과 비밀번호 찾기에 사용됩니다.")
                .font(.subheadline)
                .foregroundStyle(Color.primary.opacity(0.7))
            
            HStack {
                // MARK: - 이메일 입력 칸
                TextField("이메일", text: $emailLoginStore.email, prompt: Text("이메일").foregroundColor(.secondary.opacity(0.7)))
                    .foregroundColor(Color.primary)
                    .opacity(0.9)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .autocapitalization(.none)
                    .frame(height: 35)
                    .keyboardType(.emailAddress)
                
                // 내용 지우는 버튼
                Button {
                    emailLoginStore.email = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                }
                .foregroundColor(Color.primary.opacity(0.4))
            }
            
            Rectangle().frame(height: 1)
                .foregroundStyle(Color.secondary)
                .padding(.bottom, 5)
            
            // MARK: - 이메일 유효성 검사 메세지
            if emailLoginStore.email.isEmpty {
                Text("\(validMessage)")
                    .font(.subheadline)
                    .foregroundStyle(Color.red.opacity(0.7))
            }
            
            Spacer()
        } // VStack
        
        // MARK: - "다음" 버튼
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("다음") {
                    if isCorrectEmail(email: emailLoginStore.email) {
                        // 여기에 데이터를 파이어베이스로 보내고 중복 체크를 수행하는 코드를 추가합니다.
                        emailLoginStore.emailCheck(email: emailLoginStore.email) { isUnique in
                            // 중복 체크 결과를 업데이트합니다.
                            uniqueEmail = isUnique
                            if isUnique {
                                // 중복이 없으면 회원가입 뷰로 이동
                                self.uniqueEmail = true
                                self.isSigninLinkActive = true
                            } else {
                                // 이메일이 중복이 있을 때 비밀번호 입력창으로 이동
                                self.isLoginLinkActive = true
                            }
                        }
                    } else {
                        validMessage = "이메일형식이 유효하지 않습니다"
                        emailLoginStore.email = ""
                    }
                }
                .foregroundColor(.blue)
                .font(.headline)
                .padding(.trailing, 5)
                .disabled(emailLoginStore.email.isEmpty)
            } // ToolbarItem
        } // toolbar
        
        // MARK: - Bool값에 따른 이동
        .navigationDestination(isPresented: $isSigninLinkActive, destination: {
            SigninByEmailView(emailLoginStore: emailLoginStore)
        })
        .navigationDestination(isPresented: $isLoginLinkActive, destination: {
            LoginByEmailPWView(emailLoginStore: emailLoginStore)
        })
        .padding([.leading, .trailing])
    } // body
} // struct

#Preview {
    NavigationStack {
        LoginEmailCheckView()
    }
}
