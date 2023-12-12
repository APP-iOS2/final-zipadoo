//
//  LoginView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI
 /* 카카오 로그인 import
 import KakaoSDKCommon
 import KakaoSDKAuth
 import KakaoSDKUser
 */

// 로그인 뷰 모델
struct LoginView: View {
    /// 다크모드일 때 컬러 변경
    @Environment(\.colorScheme) var colorScheme
    
    // 카카오 로그인 미구현
    //    @StateObject var kakaoStore: KakaoStore = KakaoStore()
    
    /// 두더지 머리 위에 공간 높이
    @State private var spaceHeight: CGFloat = 500
    
    var body: some View {
        NavigationStack {
            ZStack {
                /// 배경색(반전)
                Color.primary.colorInvert()
                
                NavigationView {
                    ZStack {
                        VStack {
                            // MARK: - 두더지 이미지
                            Spacer(minLength: spaceHeight)
                             
                            imageAndLoginButtonView("Dothez")
                                .onAppear {
                                    withAnimation(.bouncy(duration: 2)) {
                                        // 애니메이션 최종 높이
                                        spaceHeight = 200
                                    }
                                }
                            
                            Spacer(minLength: 50)
                        } // VStack
                        
                        VStack {
                            Spacer(minLength: 5)
                            
                            // MARK: - 이메일 로그인 버튼
                            NavigationLink {
                                LoginEmailCheckView()
                            } label: {
                                imageAndLoginButtonView("email_login")
                            }
                            /*
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
                                imageAndLoginButtonView("kakao_login")
                            }
                            .disabled(true)
                             */
                            // MARK: - 애플 로그인 버튼
//                            Button {
//                                print("apple login")
//                            } label: {
//                                // 다크모드 아니면 애플버튼 색 반전
//                                if colorScheme == .dark {
//                                    imageAndLoginButtonView("apple_login")
//                                } else {
//                                    imageAndLoginButtonView("apple_login")
//                                        .colorInvert()
//                                }
//                            }
                             
                            // 두더지 몸통
                            Rectangle()
                                .frame(width: UIScreen.main.bounds.width * 0.9, height: 120) // 100에서 카톡로그인 삭제로 120으로 늘림
                                .foregroundColor(Color.primary)
                                .colorInvert()
                        } // VStack
                    } // ZStack
                    .frame(maxWidth: UIScreen.main.bounds.width)
                } // NavigationView
            } // ZStack
        } // NavigationStack
    }
    
    /// 두더지 이미지와 로그인버튼 뷰
    func imageAndLoginButtonView(_ imageString: String) -> some View {
        Image(imageString)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: UIScreen.main.bounds.width * 0.9)
            .cornerRadius(5)
    }
}

#Preview {
    LoginView()
}
