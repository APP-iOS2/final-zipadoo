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
    // 앱 실행 허용목록에서 카카오를 등록하고, 우리 앱으로 돌아올 수 있게하는 커스텀 URL 스킴을 설정함.
  func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:],
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
      
      if (AuthApi.isKakaoTalkLoginUrl(url)) {
                  return AuthController.handleOpenUrl(url: url)
              }

    FirebaseApp.configure()

    return true
  }
}

@main
struct ZipadooApp: App {
    @StateObject var urlHandler = URLHandler()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
