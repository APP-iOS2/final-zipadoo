//
//  ZipadooApp.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import FirebaseCore
import FirebaseMessaging
import SwiftUI
import TipKit
//import UserNotifications

// import KakaoSDKAuth
// import KakaoSDKCommon
// import KakaoSDKUser

class AppDelegate: NSObject, UIApplicationDelegate {
    lazy var locationStore = LocationStore()
    @StateObject var gpsStore = GPSStore()
    let gcmMessageIDKey = "gcm.message_id"
    
    // 파이어베이스 초기화
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        UNUserNotificationCenter.current().delegate = self
        let authOption: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOption,
            completionHandler: {_, _ in })
        
        application.registerForRemoteNotifications()
        
        print("파이어베이스 초기화 할거야!!!!!")
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Messaging.messaging().isAutoInitEnabled = true
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
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var alertStore: AlertStore = AlertStore()
    @StateObject private var widgetStore = WidgetStore()
    @StateObject private var promiseViewModel = PromiseViewModel()
    @StateObject private var friendsStore = FriendsStore()
    /*
    init() {
        // Kakao SDK 초기화
        KakaoSDK.initSDK(appKey: "2feefdcbe9f4e8d9b38b5599080f86f0") // 키는 이후에 다른 곳에 넣고 변수처리해주기
    }
     */
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State private var showMainView = false
    @State private var selectedTab = 0
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                if showMainView {
                    ContentView(selectedTab: $selectedTab)
                        .environmentObject(alertStore)
                        .environmentObject(promiseViewModel)
                        .environmentObject(widgetStore)
                        .environmentObject(friendsStore)
                        .onChange(of: scenePhase) { newScenePhase in
                            switch newScenePhase {
                            case .active:
                                Task {
                                    if let promiseId = widgetStore.widgetPromiseID {
                                        do {
                                            try await widgetStore.fetchPromise(promiseId: promiseId)
                                        } catch {
                                            print("Failed to fetch the Promise with ID \(promiseId)")
                                        }
                                    }
                                }
                            @unknown default:
                                break
                            }
                        }
                        .task {
                            try? Tips.configure([
                                .datastoreLocation(.applicationDefault)])
                        }
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
            .onOpenURL { url in
                guard url.scheme == "zipadoo" else { return }
                let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
                let promiseID = components?.queryItems?.first(where: { $0.name == "promiseID" })?.value
                widgetStore.widgetPromiseID = promiseID
                selectedTab = 0
            }
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
    // 앱 running 중 push알림 받을 때
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
                                -> Void) {
        
        let userInfo = notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler([[.banner, .list, .sound]])
        
        // 30분전에 유저 출발위치 및 myLocation 초기화
//        locationStore.myLocation = Location(participantId: AuthStore.shared.currentUser?.id ?? "", departureLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, departureLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
        locationStore.updateDeparture(newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
        print("30분전 초기화위치 값은 : \(String(describing: gpsStore.lastSeenLocation?.coordinate))")
    }
    
    // 푸시메세지를 받았을 때 유저의 액션
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        completionHandler()
    }
    
    // 백그라운드로 오는 알림 처리 메소드
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
        
        // 30분전에 유저 출발위치 및 myLocation 초기화
//        locationStore.myLocation = Location(participantId: AuthStore.shared.currentUser?.id ?? "", departureLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, departureLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
        locationStore.updateDeparture(newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
        print("30분전 초기화위치 값은 : \(String(describing: gpsStore.lastSeenLocation?.coordinate))")
        
    }
}
