//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginByEmailPWView: View {
    
    @ObservedObject var emailLoginStore: EmailLoginStore
    /// 비밀번호 보이기
    @State private var isPasswordVisible = false
    /// 패스워드 일치 체크
    @State private var isPasswordCorrect = false
    /// 비밀번호 확인 안내문구
    @State private var adminMessage: String = ""
    /// 로그인 성공 시 풀스크린 판별한 Bool 값
    @State private var loginResult: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            spacerView(50)
            
            // MARK: - 비밀번호 입력 안내 문구
            Text("비밀번호를 입력해 주세요.")
                .modifier(LoginTextStyle())
                .padding(.bottom, 10)
            
            // MARK: - 비밀번호 입력 칸
            HStack {
                // 비밀번호 숨겼을 경우 ***표시
                if isPasswordVisible == false {
                    // 비밀번호 미표시 시
                    loginTextFieldView($emailLoginStore.password, "비밀번호", isvisible: false)
                    
                } else {
                    // 비밀번호 표시 시
                    loginTextFieldView($emailLoginStore.password, "비밀번호", isvisible: true)
                }
                
                // MARK: - 비밀번호 숨기기,보이기 토글 버튼
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                        .fontWeight(.semibold)
                        .foregroundColor(Color.primary.opacity(0.5))
                        .padding(.trailing, -2)
                }
                
                // MARK: - 입력한 비밀번호 지우기 버튼
                eraseButtonView($emailLoginStore.password)
            } // HStack
            
            underLine()
            
            // MARK: - 비밀번호 확인 안내문구
            Text(adminMessage)
                .modifier(LoginMessageStyle(color: .primary))
            
            Spacer()
        } // VStack
        .padding([.leading, .trailing])
        .background(Color.clear)
        
        // MARK: - 상단 네비게이션 바 "로그인" 버튼
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("로그인") {
                    Task {
                        do {
                            let emailLoginResult: Bool = try await emailLoginStore.login()
                            loginResult = emailLoginResult
                            print(loginResult)
                        } catch {
                            print("로그인 실패")
                            adminMessage = "비밀번호를 다시 입력해주세요"
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $loginResult, content: {
            ContentView(selectedTab: .constant(0))
        })
    } // body
} // struct

#Preview {
    LoginByEmailPWView(emailLoginStore: EmailLoginStore())
}
