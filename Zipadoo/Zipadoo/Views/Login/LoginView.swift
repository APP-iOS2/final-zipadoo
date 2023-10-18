//
//  LoginView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import AuthenticationServices
// import KakaoSDKCommon
// import KakaoSDKAuth
// import KakaoSDKUser

// 로그인 뷰 모델

struct LoginView: View {
    //    @StateObject var kakaoStore: KakaoStore = KakaoStore()
    @StateObject var singinViewModel = AppleSignInViewModel()
    @AppStorage ("logState") var logState = false
    @State private var spaceHeight: CGFloat = 500 // 두더지 머리 위에 공간 높이
    @Environment(\.colorScheme) var colorScheme // 다크모드일 때 컬러 변경
    
    @State private var loginResult: Bool = false // 로그인 성공 시 풀스크린 판별한 Bool 값
    @State private var uniqueEmail: Bool = false // 이메일 중복 체크
    @State private var isSigninLinkActive: Bool = false // uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    
    let dothezColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.primary.colorInvert()// 배경색
                NavigationView {
                    ZStack {
                        VStack {
                            // MARK: - 두더지 이미지
                            Spacer(minLength: spaceHeight)
                            
                            Image("dothez")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: UIScreen.main.bounds.width * 0.9)
                                .onAppear {
                                    withAnimation(.bouncy(duration: 2)) {
                                        spaceHeight = 200// 애니메이션 최종 높이
                                    }
                                }
                            
                            Spacer(minLength: 50)
                        }
                        
                        VStack {
                            Spacer(minLength: 5)
                            
                            // MARK: - 이메일 로그인 버튼
                            NavigationLink {
                                LoginEmailCheckView()
                            } label: {
                                Image("email_login")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: UIScreen.main.bounds.width * 0.9)
                                    .cornerRadius(5)
                            }
                            
                            // MARK: - 카카오톡 로그인 버튼
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
                            
                            NavigationLink(destination: AppleSignInView(signInViewModel: singinViewModel), isActive: $isSigninLinkActive) {
                                EmptyView() // 빈 뷰를 사용하여 링크 트리거를 활성화합니다.
                            }
                            .hidden() // 빈
                            
                            // MARK: - 애플 로그인 버튼
                            SignInWithAppleButton { request in
                                print("request")
                                singinViewModel.SigninWithAppleRequest(request)
                                
                            } onCompletion: { result in
                                print("result")
                                singinViewModel.SinginWithAppleCompletion(result)
                                Task {
                                    do {
                                        try await singinViewModel.createUser()
                                        
                                    }
                                }
//                                Task {
//                                    do {
//                                        if isCorrectEmail(email: FirebaseAuth.Auth.auth().currentUser?.email ?? "Unknown") {
//                                            print("emailCheck")
//                                            print(FirebaseAuth.Auth.auth().currentUser?.email ?? "Unknown")
//                                            // 여기에 데이터를 파이어베이스로 보내고 중복 체크를 수행하는 코드를 추가합니다.
//                                            singinViewModel.emailCheck(email: FirebaseAuth.Auth.auth().currentUser?.email ?? "Unknown") { isUnique in
//                                                uniqueEmail = isUnique // 중복 체크 결과를 업데이트합니다.
//                                                if isUnique {
//                                                    // 중복이 없으면 회원가입 뷰로 이동
//                                                    self.uniqueEmail = true
//                                                    self.isSigninLinkActive = true
//                                                } else {
//                                                    // 이메일이 중복이 있을 때 홈 뷰로 이동
//                                                    Task {
//                                                        do {
//                                                            let emailLoginResult: Bool = try await singinViewModel.login()
//                                                            
//                                                            print(loginResult)
//                                                            loginResult = emailLoginResult
//                                                            print(loginResult)
//                                                        } catch {
//                                                            print("로그인 실패")
//                                                        }
//                                                    }
//                                                    
//                                                }
//                                            }
//                                        }
//                                    } catch {
//                                        print("로그인 실패")
//                                    }
//                                }
                                
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                            .cornerRadius(5)
                            .fullScreenCover(isPresented: $loginResult, content: {
                                ContentView()
                            })
                            //                            Button {
                            //
                            //                            } label: {
                            //                                if colorScheme == .dark {
                            //                                    Image("apple_login")
                            //                                        .resizable()
                            //                                        .aspectRatio(contentMode: .fit)
                            //                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                            //                                        .cornerRadius(5)
                            //
                            //                                } else {
                            //                                    Image("apple_login")
                            //                                        .resizable()
                            //                                        .aspectRatio(contentMode: .fit)
                            //                                        .frame(width: UIScreen.main.bounds.width * 0.9)
                            //                                        .cornerRadius(5)
                            //                                        .colorInvert()
                            //                                }
                            //                                //
                            //
                            //                            }
                            
                            ZStack {
                                // 두더지 몸통
                                Rectangle()
                                    .frame(width: UIScreen.main.bounds.width * 0.9, height: 100)
                                    .foregroundColor(Color.primary)
                                    .colorInvert()
                                
                            }
                        }
                        
                    } // ScrollView
                    .frame(maxWidth: UIScreen.main.bounds.width)
                    
                } // NavigationView
                
            } // ZStack
        } // NavigationStack
    } // body
} // struct

#Preview {
    LoginView()
}
