//
//  SettingView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import MessageUI
import SwiftUI

struct SettingView: View {
    /// 로그아웃 알람창
    @State private var isLogoutAlert: Bool = false
    /// 앱버전 문구(Project -> General -> Version에서 확인)
    private let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "버전 정보를 불러올 수 없습니다"
    
    var body: some View {
        Form {
            // MARK: - 정보 수정
            Section {
                NavigationLink {
                    EditProfileView(emailLoginStore: EmailLoginStore())
                } label: {
                    Text("회원정보 수정")
                }
                
                NavigationLink {
                    EditPasswordView()
                } label: {
                    Text("비밀번호 변경")
                }
            }
            
            // MARK: - 앱정보
            Section {
                NavigationLink {
                    AppInfoView()
                } label: {
                    HStack {
                        Text("앱 정보")
                        Spacer()
                        Text("ver \(appVersion)")
                            .foregroundColor(.secondary)
                    }
                }

                NavigationLink {
                    DeveloperProfileView()
                } label: {
                    Text("개발자")
                }
                
                // 1:1 문의하기
                NavigationLink {
                    Form {
                        Button(action: {
                            // 미리 만들어둔 오픈채팅 url
                            let url = URL(string: "https://open.kakao.com/o/s2WMpYMf")!
                            UIApplication.shared.open(url)
                        }, label: {
                            askCellView("오픈카톡으로 연락하기")
                        })
                        
                        Button(action: {
                            // 메일앱이 깔려있으면 가능
                            EmailController.shared.sendEmail(subject: "제목을 입력해주세요", body: "문의 내용을 입력해주세요", to: "someday0307@gmail.com")
                        }, label: {
                            askCellView("이메일로 연락하기")
                        })
                    }
                    .foregroundColor(.primary)
                    .navigationTitle("1:1 문의하기")
                    .navigationBarTitleDisplayMode(.inline)
                    
                } label: {
                    Text("1:1 문의하기")
                }
            } // Section
            
            // MARK: - 로그아웃
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
        } // Form
        .navigationTitle("설정")
    } // body
    
    /// 1:1 문의하기(오픈채팅, 이메일)
    private func askCellView(_ method: String) -> some View {
        HStack {
            Text(method)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.footnote)
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
        }
    }
}
/// 이메일로 문의하기
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
