//
//  SettingView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI
import MessageUI

struct SettingView: View {
    
    @State private var isOnAlarm: Bool = true
    @State private var isOnGPS: Bool = true
    @State private var isLogoutAlert: Bool = false
    @State private var emailAddress = "example@email.com"
    private let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "버전 정보를 불러올 수 없습니다"
    
    var body: some View {
        Form {
            Section {
                Toggle("알림 설정", isOn: $isOnAlarm)
                Toggle("위치 공개", isOn: $isOnGPS)
            }
            
            Section {
                NavigationLink {
                    EditProfileView()
                } label: {
                    Text("회원정보 수정")
                }
                
                NavigationLink {
                    EditPasswordView()
                } label: {
                    Text("비밀번호 변경")
                }
                
                NavigationLink {
                    List {
                        Button(action: {
                            let url = URL(string: "https://open.kakao.com/o/s2WMpYMf")!
                            UIApplication.shared.open(url)
                        }, label: {
                            HStack {
                                Text("오픈카톡으로 연락하기💬")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        })
                        Button(action: {
                            EmailController.shared.sendEmail(subject: "제목을 입력해주세요", body: "문의 내용을 입력해주세요", to: "someday0307@gmail.com")
                        }, label: {
                            HStack {
                                Text("이메일로 연락하기✉️")
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                        })
                    }
                    .foregroundColor(.primary)
                    .navigationTitle("1:1 문의하기")
                    .navigationBarTitleDisplayMode(.inline)
                } label: {
                    Text("1:1 문의하기")
                }
            }
            
            NavigationLink {
                AppInfoView()
            } label: {
                HStack {
                    Text("앱 정보")
                    Spacer()
                    Text("\(appVersion)")
                        .foregroundColor(.gray)
                }
            }
            
            NavigationLink {
                OpenSourceView()
            } label: {
                Text("오픈소스 라이선스")
            }
            
            NavigationLink {
                DeveloperProfileView()
            } label: {
                Text("개발자")
            }
            
            // 로그아웃
            Section {
                Button {
                    isLogoutAlert.toggle()
                } label: {
                    Text("로그아웃")
                        .foregroundStyle(.red)
                }
                .alert(isPresented: $isLogoutAlert) {
                    Alert(
                        title: Text(""),
                        message: Text("로그아웃됩니다"),
                        primaryButton: .default(Text("취소"), action: {
                            isLogoutAlert = false
                        }),
                        secondaryButton: .destructive(Text("로그아웃"), action: {
                            isLogoutAlert = false
                            Task {
                                try await AuthStore.shared.logOut()
                            }
                        })
                    )
                }
            }
        }
        .navigationTitle("설정")
    }
}

struct OpenSourceView: View {
    var body: some View {
        Text("오픈 소스 리스트")
            .navigationTitle("오픈소스 라이선스")
            .navigationBarTitleDisplayMode(.inline)
    }
}

class EmailController: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailController()
    private override init() { }
    
    func sendEmail(subject: String, body: String, to: String) {
        if !MFMailComposeViewController.canSendMail() {
            print("메일 앱이 없어 보낼 수 없음")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients([to])
        mailComposer.setSubject(subject)
        mailComposer.setMessageBody(body, isHTML: false)
        EmailController.getRootViewController()?.present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        EmailController.getRootViewController()?.dismiss(animated: true, completion: nil)
    }
    
    static func getRootViewController() -> UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        return windowScene?.windows.first?.rootViewController
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
