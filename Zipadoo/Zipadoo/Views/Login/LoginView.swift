//
//  LoginView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI
import AuthenticationServices
// import KakaoSDKCommon
// import KakaoSDKAuth
// import KakaoSDKUser

// 로그인 뷰 모델

struct LoginView: View {
    
    @State private var isSigninLinkActive: Bool = false // uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    @State private var isLoginLinkActive: Bool = false // uniqueEmail = true일 경우 로그인뷰 버튼으로 활성화
    @State private var isLoggedIn = false
    //    @StateObject var kakaoStore: KakaoStore = KakaoStore()
    @ObservedObject var appleLoginViewModel: AppleLoginViewModel
    @ObservedObject var emailLoginStore: EmailLoginStore
    @State private var spaceHeight: CGFloat = 500 // 두더지 머리 위에 공간 높이
    let dothezColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black // 배경색
                NavigationView {
                    ZStack {
                        VStack {
                            // MARK: -두더지 이미지
                            Spacer(minLength: spaceHeight)
                            Image("Dothez")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .onAppear {
                                    withAnimation(.interactiveSpring(duration: 2)) {
                                        spaceHeight = 200// 애니메이션 최종 높이
                                    }
                                }
                            Spacer(minLength: 50)
                        }
                        
                        VStack {
                            Spacer(minLength: 5)
                            
                            // MARK: -이메일 로그인 버튼
                            NavigationLink {
                                LoginEmailCheckView()
                            } label: {
                                Image("email_login")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .cornerRadius(5)
                            }
                            
                            // MARK: -카카오톡 로그인 버튼
                            Button {
                                /*
                                 kakaoStore.kakaoLogin()
                                 
                                 Task {
                                 do {
                                 try await authStore.addUserData()
                                 } catch {
                                 
                                 }
                                 }
                                 */
                                print("Kakao Login Button")
                            } label: {
                                Image("kakao_login")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .cornerRadius(5)
                            }
                            .disabled(true)
                            
                            // MARK: - 애플 로그인 버튼
                            NavigationLink(destination: SigninByAppleIDView(appleLoginViewModel: appleLoginViewModel), isActive: $isLoggedIn) {
                                EmptyView() // 빈 뷰를 사용하여 링크 트리거를 활성화합니다.
                            }
                            .hidden() // 빈
                            
                            SignInWithAppleButton(.signIn) { request in
                                appleLoginViewModel.handleSignInWithAppleRequest(request)
                            } onCompletion: { result in
                                Task {
                                    do {
                                        try await appleLoginViewModel.handleSignInWithAppleCompletion(result)
                                        
                                        print("애플 로그인 성공!")
                                        isLoggedIn = true
                                    } catch {
                                        
                                    }
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 45)
                            .signInWithAppleButtonStyle(.white)

                            ZStack {
                                // 두더지 몸통
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
                                    .foregroundColor(Color(dothezColor))
                            }
                        }
                        
                    } // ScrollView
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    .background(Color.black, ignoresSafeAreaEdges: .all)
                } // NavigationStack
                
            } // ZStack
        } // body
    }
} // struct

#Preview {
    LoginView(appleLoginViewModel: AppleLoginViewModel(), emailLoginStore: EmailLoginStore())
}
