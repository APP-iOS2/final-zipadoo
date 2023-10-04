//
//  MyPageView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    
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
    
    let dummyImageString: String = "https://cdn.discordapp.com/attachments/1153285599625748531/1154611582748336148/9b860155ad6b6c37.png"

    let dummyKm: Int = 1000
    @State var isShownFullScreenCover = false
    @State private var progressBarValue: Double = 0.8
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    // 프로필 이미지
                    ProfileImageView(imageString: userImageString, size: .large)
 
                    /*
                    AsyncImage(url: URL(string: dummyImageString)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .cornerRadius(10000)
                    } placeholder: {
                        ProgressView()
                    }
                     */
                    
                    Spacer()
                    // 프로필 기능모음
                    VStack(alignment: .trailing) {
//                        NavigationLink {
//                            SettingView()
//                        } label: {
//                            Image(systemName: "gearshape")
//                                .foregroundColor(.black)
//                        }
//                        .padding(.bottom)
                        Text("이재승 님")
                            .font(.title2)
                            .bold()
                            .padding(.bottom)
                        NavigationLink {
                            MyPotatoView()
                        } label: {
                            HStack {
                                Image(systemName: "bitcoinsign.circle.fill")
                                Text("1,000")
                                    .underline()
                            }
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                        }
                        Button {
                            isShownFullScreenCover.toggle()
                        } label: {
                            Text("충전하기")
                                .font(.title3)
                                .bold()
                                .padding(.top, 5)
                        }
                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                        })
                    }
                    .padding(.horizontal, 12)
                }
                .padding(.bottom)
                
                Divider()
                
                HStack {
                    Text("지각 깊이")
                        .font(.headline)
                    Spacer()
                    Text("지하 \(dummyKm)km")
                }
                .padding(.top)
                
                MyPageProgressBar(progress: $progressBarValue)
//                    .onAppear {
//                        withAnimation(.linear(duration: 3)) {
//                            progressBarValue = 0.8
//                        }
//                    }
                
                HStack {
                    Text("이대로 가다간,, 친구들한테 파묻히겠어요 ㅠ")
                        .font(.footnote)
                        .lineLimit(1)
                    Spacer()
                    Text("지각률 80%")
                        .foregroundColor(.red)
                }
                
                Divider()
                
                NavigationLink {
                    PastPromiseView()
                } label: {
                    HStack {
                        Text("지난 약속")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding(.top)
                    .padding(.bottom)
                }
                
                Divider()
                
                Text("받은 매너 평가")
                    .font(.headline)
                    .padding(.top)
                    .padding(.bottom)
                
                Group {
                    
                    HStack {
                        Image(systemName: "person.2")
                        Text("4")
                        Text("약속 진짜 안지켜요")
                            .padding(10)
                            .background(.gray)
                            .cornerRadius(80)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
                        Text("3")
                        Text("진짜 지각만해서 지각에 묻어버리고 싶어요")
                            .padding(10)
                            .background(.gray)
                            .cornerRadius(80)
                            .opacity(0.5)
                    }
                    
                    HStack {
                        Image(systemName: "person.2")
                        Text("12")
                        Text("한 20분 정도 늦어요")
                            .padding(10)
                            .background(.gray)
                            .cornerRadius(80)
                            .opacity(0.5)
                    }
                    
                }
                .font(.footnote)
                Spacer()
            }
            .padding()
            
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.black)
                    }
                }
            }
            
        }
    }
}

#Preview {
    MyPageView()
}

struct MyPageProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 25)
                    .cornerRadius(5)
                    .foregroundColor(.gray)
                    .opacity(0.5)
                
                ZStack {
                    Rectangle()
                        .frame(width: CGFloat(progress) * UIScreen.main.bounds.width, height: 25)
                        .cornerRadius(5)
                        .foregroundColor(.brown)
                    
                    Text("지각횟수 10회")
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
