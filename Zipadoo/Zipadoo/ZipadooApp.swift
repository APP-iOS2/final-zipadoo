//
//  ZipadooApp.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import FirebaseCore
import FirebaseMessaging
import SwiftUI
//import UserNotifications

// import KakaoSDKAuth
// import KakaoSDKCommon
// import KakaoSDKUser

class AppDelegate: NSObject, UIApplicationDelegate {
    let gcmMessageIDKey = "gcm.message_id"
    
    // 파이어베이스 초기화
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
                
        UNUserNotificationCenter.current().delegate = self
        
        print("파이어베이스 초기화 할거야!!!!!")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
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
    @StateObject var alertStore: AlertStore = AlertStore()
    /*
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "2feefdcbe9f4e8d9b38b5599080f86f0") // 키는 이후에 다른 곳에 넣고 변수처리해주기
    }
     */
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(alertStore)
//                .onOpenURL(perform: { url in
//                    if AuthApi.isKakaoTalkLoginUrl(url) {
//                        AuthController.handleOpenUrl(url: url)
//                    }
//                })
        }
    }
}

extension AppDelegate: MessagingDelegate {
    
    // fcm 등록 토큰을 받았을 때
    internal func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {

        print("토큰을 받았다")
        // Store this token to firebase and retrieve when to send message to someone...
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        
        // Store token in Firestore For Sending Notifications From Server in Future...
        
        print(dataDict)
     
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 푸시 메세지가 앱이 켜져있을 때 나올떄
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        
        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        
        print(userInfo)
        
        completionHandler([[.banner, .badge, .sound]])
    }
    
    // 푸시메세지를 받았을 떄
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        // Do Something With MSG Data...
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
}
