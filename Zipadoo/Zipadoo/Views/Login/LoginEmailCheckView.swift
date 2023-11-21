//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginEmailCheckView: View {
    
    @ObservedObject private var emailLoginStore: EmailLoginStore = EmailLoginStore()
    
    /// 이메일 중복 체크
    @State private var uniqueEmail: Bool = false
    /// 유효성 확인 메세지
    @State private var validMessage: String = ""
    /// uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    @State private var isSigninLinkActive: Bool = false
    /// uniqueEmail = true일 경우 로그인뷰 버튼으로 활성화
    @State private var isLoginLinkActive: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            
            spacerView(50)
            
            // MARK: - 상단 문구
            Text("이메일을 입력해 주세요.") // 상단 안내 문구
                .modifier(LoginTextStyle())
            
            Text("로그인과 비밀번호 찾기에 사용됩니다.")
                .modifier(LoginMessageStyle(color: .primary))
            
            // TextField
            HStack {
                loginTextFieldView($emailLoginStore.email, "이메일", isvisible: true)
                    .keyboardType(.emailAddress)
                
                eraseButtonView($emailLoginStore.email)
            }
            underLine()
            
            // MARK: - 이메일 유효성 검사 메세지
            if emailLoginStore.email.isEmpty {
                Text("\(validMessage)")
                    .modifier(LoginMessageStyle(color: .red))
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
