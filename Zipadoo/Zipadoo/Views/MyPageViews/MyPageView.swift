//
//  MyPageView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI
import WidgetKit

struct MyPageView: View {
    @EnvironmentObject private var promiseViewModel: PromiseViewModel
    @EnvironmentObject var widgetStore: WidgetStore
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
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // MARK: - 프로필 사진, 이름, 감자
                    VStack(spacing: 5) {
                        HStack {
                            // 프로필 이미지
                            
                            ProfileImageView(imageString: currentUser?.profileImageString ?? userImageString, size: .regular)
                                .overlay(
                                    Circle()
                                        .stroke(Color.secondary, lineWidth: 1)
                                )
                            
                            Group {  // 칭호, 이름, 위치
                                VStack(alignment: .leading) {
                                    // 닉네임, 지각 깊이(위치)
                                    VStack {
                                        HStack {
                                            VStack {
                                                HStack {
                                                    Text("지각쟁이") // 칭호
                                                        .font(.subheadline)
                                                        .foregroundStyle(.secondary)
                                                    Spacer()
                                                }
                                                HStack {
                                                    Text("\(currentUser?.nickName ?? "안나옴") 님")
                                                        .font(.title3)
                                                        .fontWeight(.semibold)
                                                    Spacer()
                                                }
                                            }
                                            Spacer()
                                            
                                        }
                                        .padding(.bottom, 10)
                                        
                                        HStack {
                                            
                                            Spacer()
                                        }
                                        
                                    }
                                    
                                }
                                .padding(.leading, 10)
                                
                            }
                        }
                        .padding(.bottom, 30)
                        
                        // 감자 코인
                        
                        .padding(.bottom, 10)
                        
                        Group {
                            HStack {
                                NavigationLink {
                                    MyPotatoView()
                                } label: {
                                    Image("potato")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 23, height: 20)
                                    
                                    Text("감자")
                                        .foregroundColor(.secondary)
                                        .frame(width: 30, height: 20)
                                    
                                    Spacer()
                                    
                                }
                                Text("\(currentUser?.potato ?? 0)")
                                    .fontWeight(.semibold)
                                
                            }
                            
                            HStack {
                                Text("₩")
                                    .fontWeight(.regular)
                                    .padding(3)
                                    .overlay {
                                        Circle()
                                            .stroke(Color.primary, lineWidth: 1)
                                    }
                                    .frame(width: 23, height: 20)
                                
                                Text("캐시")
                                    .foregroundColor(.secondary)
                                    .frame(width: 30, height: 20)
                                
                                Spacer()
                                Text("30,000")
                                    .fontWeight(.semibold)
                                
                            }
                        }
                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                        }) // 감자코인
                        .font(.headline)
                        
                        Divider()
                            .padding(.vertical, 15)
                        HStack {
                            
                            NavigationLink {
                                MyPotatoView()
                            } label: {
                                HStack {
                                    Text("감자 이용내역 >")
                                        .fontWeight(.light)
                                    Spacer()
                                    Image(systemName: "creditcard")
                                    Text("충전")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.primary)
                                .font(.headline)
                                
                            }
                            
                        }
                        .padding(.bottom, 15)
                        
                    }
                    .padding()
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    
                    // MARK: - 지각깊이
                    
                    VStack {
                        HStack {
                            Text("지각 깊이")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                        }
                        .padding(.vertical)
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Spacer()
                                
                                Text("지하 \(currentUser?.crustDepth ?? 100)km")
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                
                                Text("지각률 0%")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                
                                Text("지각횟수 0회")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("약속을 잘 지켜보아요")
                                    .foregroundColor(.secondary)
                                    .font(.caption)
                                    .padding(.vertical, 5)
                                
                            }
                        }
                        
                        ZStack {
                            HStack {
                                Image("land3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(RoundedRectangle(cornerRadius: 5).size(width: 330, height: 200))
                            }
                            VStack {
                                MyPageProgressBar(progress: $progressBarValue)
                                //                    .onAppear {
                                //                        withAnimation(.linear(duration: 3)) {
                                //                            progressBarValue = 0.8
                                //                        }
                                //                    }
                            }
                        }
                    }
                    .padding()
                    
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    .padding(.top, 15)
                    
                    // MARK: - 지난 약속
                    VStack {
                        NavigationLink {
                            PastPromiseView()
                                .environmentObject(promiseViewModel)
                        } label: {
                            HStack {
                                Text("지난 약속")
                                Spacer()
                                Image(systemName: "chevron.right")
                                
                            }
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                            .padding(.top)
                            .padding(.bottom)
                        }
                        
                    }
                    .padding()
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    .padding(.vertical, 15)
                    
                    // MARK: - 획득 배지
                    VStack {
                        HStack {
                            Text("획득 배지")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.vertical)
                            Spacer()
                        }
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
                        Spacer()
                    }
                    .padding()
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    
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
                    // ScrollView
                }
            }
            .navigationDestination(isPresented: $widgetStore.isShowingDetailForWidget) {
                if let promise = widgetStore.widgetPromise {
                    PromiseDetailView(promise: promise)
                }
            }
        }
    }
}

#Preview {
    MyPageView()
        .environmentObject(PromiseViewModel())
}

struct MyPageProgressBar: View {
    @Binding var progress: Double
    
    var body: some View {
        VStack {
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 30)
                    .cornerRadius(5)
                    .foregroundStyle(.zipadoo.opacity(0.3))
                 
                ZStack {
                    Rectangle()
                        .frame(width: CGFloat(progress) * 330, height: 30)
                        .cornerRadius(5)
                        .foregroundColor(.zipadoo)
                    
                    VStack {
                        Image("dothez")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30)
//                            .rotationEffect(Angle(degrees: 90))
                            .shadow(radius: 10, x: 1, y: 1)
                    }
                }
            }
        }
    }
}
