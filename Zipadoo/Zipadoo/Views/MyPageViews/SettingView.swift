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
    
    var body: some View {
        List {
            Toggle("알림 설정", isOn: $isOnAlarm)
            Toggle("위치 공개", isOn: $isOnGPS)
            NavigationLink {
                VStack {
                    Text("현재 로그인 아이디: 이재승짱짱맨")
                    Text("계정 생성 날짜: 1875년 1월 28일")
                    Spacer()
                }
                .navigationTitle("계정 정보 관리")
            } label: {
                Text("계정 정보 관리")
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
        .listStyle(.plain)
        .navigationTitle("설정")
    }
}

#Preview {
    NavigationStack {
        SettingView()
    }
}
