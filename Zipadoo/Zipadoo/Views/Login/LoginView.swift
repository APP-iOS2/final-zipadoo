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
                            
                            // MARK: - 애플 로그인 버튼
                            SignInWithAppleButton { request in
                                singinViewModel.SigninWithAppleRequest(request)
                            } onCompletion: { result in
                                singinViewModel.SinginWithAppleCompletion(result)
                            }
                            .frame(width: UIScreen.main.bounds.width * 0.9, height: 50)
                            .cornerRadius(5)
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
