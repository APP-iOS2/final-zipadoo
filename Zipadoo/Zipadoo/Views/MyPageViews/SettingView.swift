//
//  SettingView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct SettingView: View {
    
    @State private var isOnAlarm: Bool = true
    @State private var isOnGPS: Bool = true
    
    @State private var isLogoutAlert: Bool = false
    
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
                        Button(action: {}, label: {
                            Text("오픈카톡으로 연락하기")
                        })
                        Button(action: {}, label: {
                            Text("이메일로 연락하기")
                        })
                    }
                    .navigationTitle("개발자에게 연락하기")
                    
                } label: {
                    Text("건의 사항")
                }
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
//        .listStyle(.plain)
        .navigationTitle("설정")
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
