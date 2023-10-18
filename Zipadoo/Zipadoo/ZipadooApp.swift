//
//  ZipadooApp.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import FirebaseCore
import SwiftUI
// import KakaoSDKAuth
// import KakaoSDKCommon
// import KakaoSDKUser

class AppDelegate: NSObject, UIApplicationDelegate {
    // 파이어베이스 초기화
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        print("파이어베이스 초기화 할거야!!!!!")
        return true
    }
    
    /*
    // 카카오 초기화
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            print("카카오 초기화 할거야!!!!!")
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }
     */
}

@main
struct ZipadooApp: App {
    
    /*
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "2feefdcbe9f4e8d9b38b5599080f86f0") // 키는 이후에 다른 곳에 넣고 변수처리해주기
    }
     */
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showMainView = false
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showMainView {
                    ContentView()   
                } else {
                    LaunchScreen()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showMainView = true
                                }
                            }
                        }
                }
            }
//                .onOpenURL(perform: { url in
//                    if AuthApi.isKakaoTalkLoginUrl(url) {
//                        AuthController.handleOpenUrl(url: url)
//                    }
//                })
        }
    }
}
