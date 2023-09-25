//
//  ZipadooApp.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI
import FirebaseCore
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        
        FirebaseApp.configure()
        
        if AuthApi.isKakaoTalkLoginUrl(url) {
            return AuthController.handleOpenUrl(url: url)
        } else {
            return false
        }
    }
}

@main
struct ZipadooApp: App {
    @State private var openURL: URL?
    
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "2feefdcbe9f4e8d9b38b5599080f86f0")
    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            // onOpenURL()을 사용해 커스텀 URL 스킴 처리
            KakaoTest()
                .onOpenURL(perform: { url in
                if AuthApi.isKakaoTalkLoginUrl(url) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
        }
    }
}
