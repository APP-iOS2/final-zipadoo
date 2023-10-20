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
    @State var isShownFullScreenCover = false
    @State private var progressBarValue: Double = 0
    // 지각 깊이 데이터 프로퍼티
    // 지각률에 따라 메시지 다르게 보여주기
    let tradyCount = AuthStore.shared.currentUser?.tradyCount ?? 0
    let promiseCount = AuthStore.shared.currentUser?.promiseCount ?? 1
    var tradyPercent: Int {
        if promiseCount == 0 {
            return 0
        }
        return tradyCount/promiseCount*100
    }
//    @State private var tradyPercent: Double = 0
    var promisePercent: Int {
        return 100 - tradyPercent
    }
    
    var dooAction: String {
        if let moleImageString = currentUser?.moleImageString {
            switch moleImageString {
            case "doo1": return "doo1_1"
            case "doo2": return "doo2_1"
            case "doo3": return "doo3_1"
            case "doo4": return "doo4_1"
            case "doo5": return "doo5_1"
            case "doo6": return "doo6_1"
            case "doo7": return "doo7_1"
            case "doo8": return "doo8_1"
            case "doo9": return "doo9_1"
            default:
                return "doo1_1"
            }
        } else {
            return "doo1_1"
        }
    }
    
    var tradyMessage: String {
        switch promisePercent {
        case 0: "약속이 뭔말인지 몰라요?"
        case 1...30: "지각을 넘어 핵으로 들어가겠어요"
        case 31...50: "슬슬 지각쟁이소리 들어도 할말없음"
        case 51...70: "조금만 더 약속에 신경써요"
        case 71...80: "나쁘지 않아요"
        case 81...90: "오 꽤 지키는데요?"
        case 91...95: "너무 좋아요!"
        case 96...100: "약속의 신"
        default:
            "약속이 뭔말인지 몰라요?"
        }
    }
    
    var tradyTitle: String {
        switch promisePercent {
        case 0: "플랭크톤"
        case 1...30: "자벌레"
        case 31...50: "일탈쟁이"
        case 51...70: "어중간지각쟁이"
        case 71...80: "일반인"
        case 81...90: "약속의 수호자"
        case 91...95: "친구들의 사랑"
        case 96...100: "약속의 신"
        default:
            "플랭크톤"
        }
    }
    
    var crustDepth: String {
        switch promisePercent {
        case 0: "5,151 ~ 6,371km--내핵"
        case 1...30: "2,891 ~ 5,151km--외핵"
        case 31...50: "670 ~ 2,891km--하부맨틀"
        case 51...70: "6-35 ~ 670km--상부맨틀"
        case 71...80: "0 ~ 30-35km--지각"
        case 81...90: "0km--지표"
        case 91...95: "0 ~ 10km--하층대기,대류권"
        case 96...100: "10 ~ 50km--성층권"
        default:
            "5,151 ~ 6,371km--내핵"
        }
    }
    
    var crustBackgroundImage: String {
        switch promisePercent {
        case 0: "crust7"
        case 1...30: "crust6"
        case 31...50: "crust5"
        case 51...70: "crust4"
        case 71...80: "crust3"
        case 81...90: "crust2"
        case 91...95: "crust1"
        case 96...100: "crust0"
        default:
            "crust7"
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    VStack(spacing: 5) {
                        // MARK: - 유저정보
                        HStack {
                            // 프로필 이미지
                            ProfileImageView(imageString: currentUser?.profileImageString ?? userImageString, size: .regular)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 3)
                                        .fill(.secondary)
                                )
                                .padding(.trailing, 10)
                            
                            // 칭호, 이름, 위치
                            VStack(alignment: .leading) {
                                Text(tradyTitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("\(currentUser?.nickName ?? "안나옴") 님")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                                // 닉네임, 지각 깊이(위치)
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 15)
                        
                        // MARK: - 감자 , 캐시
                        Group {
                            HStack {
                                Image("potato")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 23, height: 20)
                                
                                Text("감자")
                                    .foregroundColor(.secondary)
                                Spacer()
                                
                                Text("\(currentUser?.potato ?? 0)")
                                    .fontWeight(.semibold)
                                
                                Text("감자")
                            }
                            .padding(.bottom, 5)
                            
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
                                
                                Spacer()
                                
                                Text("30,000")
                                    .fontWeight(.semibold)
                                
                                Text("원")
                                
                            }
                        }
                        .font(.headline)
                        
                        // MARK: - 감자 이용내열, 충전버튼
                        Divider()
                            .padding(.vertical, 15)
                        
                        HStack {
                            
                            NavigationLink {
                                MyPotatoView()
                            } label: {
                                HStack {
                                    Text("감자 이용내역")
                                    Image(systemName: "chevron.right")
                                        .fontWeight(.light)

                                }
                            }
                            Spacer()
                            
                            Button {
                                isShownFullScreenCover = true
                            } label: {
                                Image(systemName: "creditcard")
                                Text("충전")
                                    .fontWeight(.semibold)
                            }

                        }
                        .foregroundColor(.primary)
                        .font(.headline)
                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                        }) // 감자코인
                        
                    }
                    .padding(20)
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    
                    // MARK: - 지각깊이
                    
                    VStack(alignment: .leading) {
                        Text("지각 깊이")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        HStack(alignment: .center) {
                            Text(crustDepth)
                            Spacer()
                            Text("  \(tradyMessage)")
                        }
                        .foregroundStyle(.secondary)
                        .padding(.top, 1)
                        
                        ZStack {
                            Image(crustBackgroundImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.white, lineWidth: 5))
                        }
                        .overlay(alignment: .topTrailing) {
                            // 약속 데이터
                            HStack {
                                VStack {
                                    Text("지각률 \(tradyPercent)%")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.red)
                                    
                                    Text("지각횟수 \(tradyCount)회")
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    
                                }
                            }
                            .padding(3)
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 1.2)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 15))
                        }
                        .overlay(alignment: .leading) {
                            // 두더지 이미지
                            Image(dooAction)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100)
                                .padding(.leading, 20)
                        }
                    }
                    .padding(20)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.primary)
                            .opacity(0.05)
                            .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        
                    )
                    .padding(.vertical, 15)
                    
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
                        }

                    }
                    .padding(20)
                    .overlay(
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.primary)
                                .opacity(0.05)
                                .shadow(color: .primary, radius: 10, x: 5, y: 5)
                        }
                        
                    )
                    /*
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
                    */
                    
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
                } // ScrollView
            }
            .padding(10)
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
