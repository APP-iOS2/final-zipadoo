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
    
    let dummyKm: Int = 1000
    @State var isShownFullScreenCover = false
    @State private var progressBarValue: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    VStack(alignment:.center) {
                        // 프로필 이미지
                        ProfileImageView(imageString: user.profileImageString, size: .large)
                        Text("\(user.nickName ) 님")
                            .font(.title2)
                            .bold()
                       
                    }
                    Spacer()
                    .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                        TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                    })
                }
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
                }.font(.headline)
                    .fontWeight(.semibold)
                
//                VStack {
//                    ZStack(alignment: .leading) {
//                        Rectangle()
//                            .frame(height: 30)
//                            .cornerRadius(5)
//                            .foregroundStyle(.brown.opacity(0.3))
//                        
//                        ZStack {
//                            Rectangle()
//                                .frame(width: CGFloat() * UIScreen.main.bounds.width, height: 25)
//                                .cornerRadius(5)
//                                .foregroundColor(.brown)
//                            
//                       
//                        }
//                    }
//                }
                //                    .onAppear {
                //                        withAnimation(.linear(duration: 3)) {
                //                            progressBarValue = 0.8
                //                        }
                //                    }
                
//                HStack {
//                    Text("약속을 잘 지켜보아요~")
//                        .font(.footnote)
//                        .lineLimit(1)
//                    Spacer()
//                    // 계산 필요
//                    Text("지각률 0%")
//                        .foregroundColor(.red)
//                }
//                Divider()
//                
//                Text("받은 매너 평가")
//                    .font(.headline)
//                    .padding(.top)
//                    .padding(.bottom)
//                
//                Group {
//                    
//                    HStack {
//                        Image(systemName: "person.2")
//                            .frame(width: 15)
//                        Text("4")
//                            .frame(width: 15)
//                        Text("약속 진짜 안지켜요")
//                            .padding(10)
//                            .background(.brown.opacity(0.3))
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                    
//                    HStack {
//                        Image(systemName: "person.2")
//                            .frame(width: 15)
//                        Text("3")
//                            .frame(width: 15)
//                        Text("진짜 지각만해서 지각에 묻어버리고 싶어요")
//                            .padding(10)
//                            .background(.brown.opacity(0.3))
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                    
//                    HStack {
//                        Image(systemName: "person.2")
//                            .frame(width: 15)
//                        Text("12")
//                            .frame(width: 15)
//                        Text("한 20분 정도 늦어요")
//                            .padding(10)
//                            .background(.brown.opacity(0.3))
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                    }
//                }
//                .font(.footnote)
                Spacer()
            }
            .padding()
            .navigationTitle("프로필")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    FriendProfileView(user: .sampleData)
}
