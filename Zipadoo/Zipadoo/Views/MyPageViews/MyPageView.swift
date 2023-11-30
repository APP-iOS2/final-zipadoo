//
//  MyPageView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPageView: View {
    // 지난 약속을 위한 프로퍼티 래퍼
    @EnvironmentObject private var promiseViewModel: PromiseViewModel
    /// 감자 충전 뷰 Bool값
    @State private var isShownFullScreenCover = false
    /// 프로그래스바 높이
    @State private var progressBarValue: Double = 0
    // MARK: - 유저 프로퍼티
    /// 현재 로그인된 유저(옵셔널)
    let currentUser: User? = AuthStore.shared.currentUser
    /// 유저가 있으면 유저프로필 String 저장
    var userImageString: String {
        return currentUser?.profileImageString ?? "defaultProfile"
    }
    // MARK: - 지각 깊이 데이터 프로퍼티
    // 지각률에 따라 메시지 다르게 보여주기
    /// 지각 수
    let tradyCount = AuthStore.shared.currentUser?.tradyCount ?? 0
    /// 약속 수
    let promiseCount = AuthStore.shared.currentUser?.promiseCount ?? 0
    /// 지각률
    var tradyPercent: Int {
        if promiseCount == 0 {
            return 0
        }
        return tradyCount/promiseCount * 100

    }
    /// 약속 지킨 횟수
    var promisePercent: Int {
        return 100 - tradyPercent
    }
    /// 두더지 이미지
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
    /// 유저 칭호 설명
    var tradyMessage: String {
        if promiseCount == 0 {
            return "약속을 잘 지켜보아요."
        } else {
            switch promisePercent {
            case 0: return "약속이 뭔말인지 몰라요?"
            case 1...30: return "지각을 넘어 핵으로 들어가겠어요"
            case 31...50: return "슬슬 지각쟁이소리 들어도 할말없음"
            case 51...70: return "조금만 더 약속에 신경써요"
            case 71...80: return "나쁘지 않아요"
            case 81...90: return "오 꽤 지키는데요?"
            case 91...95: return "너무 좋아요!"
            case 96...100: return "약속의 신"
            default:
                return "약속이 뭔말인지 몰라요?"
            }
        }
    }
    /// 약속 지킨 횟수에 따른 유저 칭호
    var tradyTitle: String {
        if promiseCount == 0 {
            return "뉴비약속러"
        } else {
            switch promisePercent {
            case 0: return "플랭크톤"
            case 1...30: return "자벌레"
            case 31...50: return "일탈쟁이"
            case 51...70: return "어중간지각쟁이"
            case 71...80: return "일반인"
            case 81...90: return "약속의 수호자"
            case 91...95: return "친구들의 사랑"
            case 96...100: return "약속의 신"
            default:
                return "플랭크톤"
            }
        }
    }
    /// 유저의 지각 깊이
    var crustDepth: String {
        if promiseCount == 0 {
            return "0km--지표"
        } else {
            switch promisePercent {
            case 0: return "5,151 ~ 6,371km--내핵"
            case 1...30: return "2,891 ~ 5,151km--외핵"
            case 31...50: return "670 ~ 2,891km--하부맨틀"
            case 51...70: return "6-35 ~ 670km--상부맨틀"
            case 71...80: return "0 ~ 30-35km--지각"
            case 81...90: return "0km--지표"
            case 91...95: return "0 ~ 10km--하층대기,대류권"
            case 96...100: return "10 ~ 50km--성층권"
            default:
                return "5,151 ~ 6,371km--내핵"
            }
        }
    }
    /// 유저의 지각 깊이에 따른 배경 이미지
    var crustBackgroundImage: String {
        if promiseCount == 0 {
            return "crust2"
        } else {
            switch promisePercent {
            case 0: return "crust7"
            case 1...30: return "crust6"
            case 31...50: return "crust5"
            case 51...70: return "crust4"
            case 71...80: return "crust3"
            case 81...90: return "crust2"
            case 91...95: return "crust1"
            case 96...100: return "crust0"
            default:
                return "crust7"
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // MARK: - 유저정보
                    VStack(spacing: 5) {
                        HStack {
                            // MARK: - 프로필 이미지
                            ProfileImageView(imageString: currentUser?.profileImageString ?? userImageString, size: .regular)
                                .overlay(
                                    Circle()
                                        .stroke(Color.gray, lineWidth: 3)
                                    // .fill(.secondary) // 사진을 흐리게하는 코드이므로 우선 주석처리
                                )
                                .padding(.trailing, 10)
                            // MARK: - 닉네임, 지각 깊이(위치)
                            VStack(alignment: .leading) {
                                Spacer()
                                Text(tradyTitle)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                
                                Text("\(currentUser?.nickName ?? "안나옴") 님")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                
                                Spacer()
                            }
                            .padding(.bottom, 16)
                            
                            Spacer()
                        }
                        .padding(.bottom, 15)
                        
                        // MARK: - 감자, 캐시 (추후 업데이트 하기)
//                        Group {
//                            HStack {
//                                Image("potato")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fill)
//                                    .frame(width: 23, height: 20)
//                                
//                                Text("감자")
//                                    .foregroundColor(.secondary)
//                                
//                                Spacer()
//                                
//                                Text("\(currentUser?.potato ?? 0)")
//                                    .fontWeight(.semibold)
//                                
//                                Text("감자")
//                            }
//                            .padding(.bottom, 5)
//                            
//                            HStack {
//                                Text("₩")
//                                    .fontWeight(.regular)
//                                    .padding(3)
//                                    .overlay {
//                                        Circle()
//                                            .stroke(Color.primary, lineWidth: 1)
//                                    }
//                                    .frame(width: 23, height: 20)
//                                
//                                Text("캐시")
//                                    .foregroundColor(.secondary)
//                                
//                                Spacer()
//                                
//                                Text("0")
//                                    .fontWeight(.semibold)
//                                
//                                Text("원")
//                                
//                            }
//                        }
//                        .font(.headline)
                        
                        // MARK: - 감자 이용내열, 충전버튼
//                        Divider()
//                            .padding(.vertical, 15)
                        
//                        HStack {
//                            NavigationLink {
//                                MyPotatoView()
//                            } label: {
//                                HStack {
//                                    Text("감자 이용내역")
//                                    Image(systemName: "chevron.right")
//                                        .fontWeight(.light)
//                                }
//                            }
//                            Spacer()
//                            
//                            Button {
//                                isShownFullScreenCover = true
//                            } label: {
//                                Image(systemName: "creditcard")
//                                Text("충전")
//                                    .fontWeight(.semibold)
//                            }
//                        }
//                        .foregroundColor(.primary)
//                        .font(.headline)
                        // MARK: - TossPay 뷰
//                        .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
//                            TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
//                        }) // 감자코인
                        
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
                    .padding(.bottom)
                    
                    // MARK: - 지각 깊이 (추후 업데이트 하기)
//                    VStack(alignment: .leading) {
//                        Text("지각 깊이")
//                            .font(.title3)
//                            .fontWeight(.semibold)
//                        
//                        HStack(alignment: .center) {
//                            Text(crustDepth)
//                            Spacer()
//                            Text("  \(tradyMessage)")
//                        }
//                        .foregroundStyle(.secondary)
//                        .padding(.top, 1)
//                        
//                        VStack {
//                            Image(crustBackgroundImage)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                                .clipShape(RoundedRectangle(cornerRadius: 10))
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 10)
//                                        .stroke(Color.white, lineWidth: 5))
//                        }
//                        .overlay(alignment: .topTrailing) {
//                            // MARK: - 약속 데이터 vytl
//                            HStack {
//                                VStack {
//                                    Text("지각률 \(tradyPercent)%")
//                                        .font(.headline)
//                                        .fontWeight(.semibold)
//                                        .foregroundColor(.red)
//                                    
//                                    Text("지각횟수 \(tradyCount)회")
//                                        .font(.subheadline)
//                                        .foregroundColor(.black)
//                                    
//                                }
//                            }
//                            .padding(3)
//                            .background(.white)
//                            .clipShape(RoundedRectangle(cornerRadius: 10))
//                            .shadow(radius: 1.2)
//                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 0, trailing: 15))
//                        }
//                        // MARK: - 두더지 이미지
//                        .overlay(alignment: .leading) {
//                            Image(dooAction)
//                                .resizable()
//                                .aspectRatio(contentMode: .fit)
//                                .frame(width: 100)
//                                .padding(.leading, 20)
//                        }
//                    }
//                    .padding(20)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundColor(.primary)
//                            .opacity(0.05)
//                            .shadow(color: .primary, radius: 10, x: 5, y: 5)
//                        
//                    )
//                    .padding(.vertical, 15)
                    
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
                    
                    // MARK: - 획득 배지 (추후 업데이트 하기)
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
                // MARK: - 설정 버튼
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            SettingView()
                        } label: {
                            Image(systemName: "gearshape")
                                .foregroundColor(.primary)
                        }
                    }
                    // MARK: - 지파두 마크
                    ToolbarItem(placement: .topBarLeading) {
                        Image("zipadooMark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                } // toolbar
            } // ScrollView
            .onAppear {
                Task {
                    try await AuthStore.shared.loadUserData()
                }
            }
        } // NavigationStack
    } // body
}

#Preview {
    MyPageView()
        .environmentObject(PromiseViewModel())
}

// MARK: - 지각 퍼센테이지 (구현이 제대로 안되고 사용하지 않아서 주석처리)
//struct MyPageProgressBar: View {
//    @Binding var progress: Double
//    
//    var body: some View {
//        VStack {
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(height: 30)
//                    .cornerRadius(5)
//                    .foregroundStyle(.zipadoo.opacity(0.3))
//                
//                ZStack {
//                    Rectangle()
//                        .frame(width: CGFloat(progress) * 330, height: 30)
//                        .cornerRadius(5)
//                        .foregroundColor(.zipadoo)
//                    
//                    VStack {
//                        Image("dothez")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 30)
//                        //                            .rotationEffect(Angle(degrees: 90))
//                            .shadow(radius: 10, x: 1, y: 1)
//                    }
//                }
//            }
//        }
//    }
//}

//#Preview {
//    MyPageProgressBar(progress: .constant(1.19))
//}
