//
//  MyPageView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {

    let dummyImageString: String = "https://cdn.discordapp.com/attachments/1153285599625748531/1154611582748336148/9b860155ad6b6c37.png"

    let dummyKm: Int = 1000
    @State var isShownFullScreenCover = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    // 프로필 이미지
                    AsyncImage(url: URL(string: dummyImageString)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 200)
                            .cornerRadius(30)
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                    // 프로필 기능모음
                    VStack(alignment: .trailing) {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(.black)
                        }
                        .padding(.bottom)
                        Text("이재승 님")
                            .padding(.bottom)
                        NavigationLink {
                            MyPotatoView()
                        } label: {
                            HStack {
                                Image(systemName: "bitcoinsign.circle.fill")
                                Text("10,000")
                            }
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                        }
                        //                        NavigationLink {
                        Button {
                            isShownFullScreenCover.toggle()
                        } label: {
                            Text("충전하기")
                                .font(.title2)
                        }
                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                        })
                    }
                }
                .padding(.leading)
                .padding(.trailing)
                
                Divider()
                
                HStack {
                    Text("지각 깊이")
                        .font(.title2)
                    Spacer()
                    Text("지하 \(dummyKm)km")
                }
                .padding(.top)
                
                Rectangle()
                    .frame(width: .infinity, height: 30)
                    .foregroundColor(.brown)
                    .cornerRadius(20)
                
                HStack {
                    Text("이대로 가다간,, 친구들한테 파묻히겠어요 ㅠ")
                    Spacer()
                    Text("지각률 80%")
                        .foregroundColor(.red)
                }
                .padding(.top)
                .padding(.bottom)
                
                Divider()
                
                NavigationLink {
                    
                } label: {
                    HStack {
                        Text("나의 약속")
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(.top)
                    .padding(.bottom)
                }
                
                Divider()
                
                Text("받은 매너 평가")
                    .font(.title2)
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
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    MyPageView()
}
