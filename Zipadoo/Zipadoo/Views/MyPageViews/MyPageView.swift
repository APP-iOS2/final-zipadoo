//
//  MyPageView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI
import WidgetKit

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
    @State private var progressBarValue: Double = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                
                HStack {
                    // 프로필 이미지
                    ProfileImageView(imageString: currentUser?.profileImageString ?? userImageString, size: .regular)
                     
//                        .overlay(
//                        Circle()
//                            .stroke(Color.secondary, lineWidth: 1)
//                        )

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
                    // 프로필 기능모음
                    VStack(alignment: .leading) {
                        //                        NavigationLink {
                        //                            SettingView()
                        //                        } label: {
                        //                            Image(systemName: "gearshape")
                        //                                .foregroundColor(.black)
                        //                        }
                        //                        .padding(.bottom)
                        HStack {
//                            Text("칭호").frame(width: 60)
//                                .foregroundColor(.secondary)
                              
                            Text("\(currentUser?.nickName ?? "안나옴") 님")
                                .font(.title2)
                                .bold()
                                .frame(width: 100)
                              
                        }
                        // 프로필 버튼 모음
                        HStack {
                            //                            NavigationLink {
                            //                                MyPotatoView()
                            //                            } label: {
                            //                                HStack {
                            //                                    Image(systemName: "bitcoinsign.circle.fill")
                            //                                    Text("\(currentUser?.potato ?? 0)")
                            //                                        .underline()
                            //                                }
                            //                                .clipShape(RoundedRectangle(cornerRadius: 4))
                            //                                .foregroundStyle(.black)
                            //                                .font(.headline)
                            //                                .bold()
                            //                            }
                            HStack {
                                Image("potato")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 25, height: 25)
                             
                                    Text("\(currentUser?.potato ?? 0)")
                                        .frame(width: 60)
                                        .padding(.leading, -15)
                                    
                            }
                            .padding(.leading, 10)
                            
                            .foregroundStyle(.primary)
                            .font(.headline)
                            .bold()
                            
                            HStack {
                                Spacer()
                            NavigationLink {
                                MyPotatoView()
                            } label: {
                                Text("내역보기")
                                    .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10))
                                    .background(.zipadoo.opacity(0.2))
                                    .clipShape(RoundedRectangle(cornerRadius: 4))
                                    .foregroundColor(.primary)
                                    .font(.headline)
                                    .bold()
                                    .padding(.top, 5)
                            }
                        }
                        }
                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                        })
                    }
                    .padding(.leading, 20)
                }
                .padding(.bottom)
                
                Divider()
                
                HStack {
                    Text("지각 깊이")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    
                    Text("지하 \(currentUser?.crustDepth ?? 100)km")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                 
                }
                .padding(.vertical)
                
                ZStack {
                    HStack {
                        Image("land2")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(RoundedRectangle(cornerRadius: 5).size(width: 200, height: 200))
                            .frame(width: 100)
                            .blur(radius: 0.5)
                    }
                        MyPageProgressBar(progress: $progressBarValue)
                        //                    .onAppear {
                        //                        withAnimation(.linear(duration: 3)) {
                        //                            progressBarValue = 0.8
                        //                        }
                        //                    }
                            .padding(.bottom, -20)
                            .padding(.trailing, 60)
                    HStack {
                        Spacer()
                        VStack(alignment: .trailing) {
                            Spacer()
                            Text("지각률 0%")
                                .foregroundColor(.red)
                                .fontWeight(.semibold)
                            
                            Text("지각횟수 0회")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                       
                                Text("약속을 잘 지켜보아요")
                                    .foregroundColor(.secondary)
                                    .font(.footnote)
                                    .padding(.vertical, 5)

                        }
                    }
                }
                
                .padding(.leading, -120)

                Divider()
                
                NavigationLink {
                    PastPromiseView()
                } label: {
                    HStack {
                        Text("지난 약속")
                        Spacer()
                        Image(systemName: "chevron.right")
                        
                    }
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top)
                    .padding(.bottom)
                }
                
                Divider()
                
                Text("획득 배지")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical)
                
                Group {
                    HStack {
                        Spacer()
                        Image("badges")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.8)
                          
                        Spacer()
                    }
                }
                
                /*
                Group {
                    
                    HStack {
                            Image(systemName: "person.2")
                                .frame(width: 15)
                                .font(.title3)
                            Text("4")
                                .font(.footnote)
                                .frame(width: 30)
                        Text("약속 진짜 안지켜요")
                            .padding(.horizontal, 5)
                            .padding(10)
                            .background(.zipadoo.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    HStack {
                            Image(systemName: "person.2")
                                .frame(width: 15)
                                .font(.title3)
                            Text("3")
                                .font(.footnote)
                                .frame(width: 30)
                        Text("진짜 지각만해서 지각에 묻어버리고 싶어요")
                            .padding(.horizontal, 5)
                            .padding(10)
                            .background(.zipadoo.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    HStack {
                            Image(systemName: "person.2")
                                .frame(width: 15)
                                .font(.title3)
                            Text("123")
                                .font(.footnote)
                                .frame(width: 30)
                        Text("한 20분 정도 늦어요")
                            .padding(.horizontal, 5)
                            .padding(10)
                            .background(.zipadoo.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                          
                    }
                    
                }
                .padding(.leading, 10)
                .font(.subheadline)
                 
                 */ // 당근마켓 매너평가
                
                Spacer()
            }
            .padding()
       
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape")
                            .foregroundColor(.primary)
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
                    .frame(width: 30, height: 120 )
                    .cornerRadius(5)
                    .foregroundStyle(.zipadoo.opacity(0.5))
                 
                ZStack {
                    Rectangle()
                        .frame(width: 30, height: CGFloat(progress) * 120)
                        .cornerRadius(5)
                        .foregroundColor(.zipadoo)
                    
                    VStack {
                        Image("dothez")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
                    }
                    
                }
            }
        }
    }
}
