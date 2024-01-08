//
//  FriendProfileView.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/11/23.
//

import SwiftUI
import WidgetKit

// 친구 프로필
struct FriendProfileView: View {
    
    @State private var isShownFullScreenCover = false
    @State private var progressBarValue: Double = 0
    
    var user: User
    /// 현재 로그인된 유저(옵셔널)
    let currentUser: User? = AuthStore.shared.currentUser
    /// 유저가 있으면 유저프로필 String저장
    var userImageString: String {
        if let user = currentUser {
            user.profileImageString
        } else {
            // 스토리지에 저장된 기본 이미지
            "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                VStack(alignment: .center) {
                    // 프로필 이미지
                    ProfileImageView(imageString: user.profileImageString, size: .large)
                    Text("\(user.nickName ) 님")
                        .font(.title2)
                        .bold()
                } // VStack
                .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                    TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                })
                .padding(.bottom)
                
                Group {
                    HStack {
                        Text("지각 깊이")
                        
                        Spacer()
                        Text("지하 \(user.crustDepth)km")
                    }
                    .padding(.vertical)
                    
                    HStack {
                        Text("지각횟수")
                        
                        Spacer()
                        Text("\(user.crustDepth)회")
                    }
                } // Group
                .font(.headline)
                .fontWeight(.semibold)
                
                Spacer()
            } // VStack
            .padding()
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
        } // NavigationStack
    } // body
} // struct
//
//#Preview {
//    FriendProfileView(user: .sampleData)
//}
