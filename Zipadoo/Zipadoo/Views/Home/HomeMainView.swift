//
//  HomeMainView.swift
//  Zipadoo
//  약속 리스트 뷰
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI
import SlidingTabView

struct HomeMainView: View {
    let user: User?
    
    //    @StateObject private var loginUser: UserStore = UserStore()
    
    @ObservedObject private var locationStore: LocationStore = LocationStore()
    @EnvironmentObject var promise: PromiseViewModel
    @EnvironmentObject var widgetStore: WidgetStore
    @State private var isShownFullScreenCover: Bool = false
    
    // 약속의 갯수 확인
    //    @State private var userPromiseArray: [Promise] = []
    
    
    // 약속 카드 테두리 색 모션회전
    @State var rotation: CGFloat = 0.0
    
    // 약속등록 버튼 바운스
    @State private var animate = false
    
    // 선택한 카드 퍼뜨리기
    @State private var isCardSpread = false
    @State private var selectedPromiseIndex: Int?
    
    var userImageString: String {
        user?.profileImageString ?? "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
    }
    
    // 기기별 화면크기 선언
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationStack {
            // 예정된 약속 리스트
            if let loginUserID = user?.id {
                ScrollView(.vertical, showsIndicators: false) {
                    if promise.fetchTrackingPromiseData.isEmpty && promise.fetchPromiseData.isEmpty {
                        VStack {
                            Image(.zipadoo)
                                .resizable()
                                .frame(width: 200, height: 200)
                            
                            Text("약속이 없어요\n 약속을 만들어 보세요!")
                                .multilineTextAlignment(.center)
                                .font(.title)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        .padding(.top, 100)
                        .padding(.horizontal, 20)
                        
                    } else {
                        // 추적중
                        HStack {
                            Text("진행중인 약속")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .padding(.horizontal, 35)
                            Spacer()
                        }
                        .padding(.bottom, -10)
                        ForEach(promise.fetchTrackingPromiseData) { promise in
                            NavigationLink {
                                PromiseDetailView(promise: promise)
                                    .environmentObject(self.promise)
                            } label: {
                                promiseListCell(promise: promise, color: .color5, isTracking: true)
                            }
                            .padding(.vertical, 15) // 리스트 패딩차이 조절용
                            
                        }
                        
                        HStack {
                            Text("예정된 약속")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .font(.title3)
                                .padding(.horizontal, 35)
                            Spacer()
                        }
                        .padding(.bottom, -10)
                        
                        ForEach(promise.fetchPromiseData.indices,id: \.self) { index in
                            NavigationLink {
                                PromiseDetailView(promise: promise.fetchPromiseData[index])
                            } label: {
                                promiseListCell(promise: promise.fetchPromiseData[index], color: .color4, isTracking: false)
                                //                                        .offset(y: isCardSpread ? 0 : CGFloat(index) * -180)
                            }
                            .overlay {
                                Rectangle()
                                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
                                    .foregroundColor(.black.opacity(isCardSpread ? 0 : 0.001))
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            //                                        isCardSpread = true
                                            isCardSpread.toggle()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                            withAnimation(.easeInOut(duration: 0.35)) {
                                                isCardSpread = false
                                            }
                                        }
                                    }
                            }
                            .offset(y: isCardSpread ? 0 : CGFloat(index) * -120)
                            
                            .padding()
                        }
                        
                        //                            .offset(y: isCardSpread ? 0 : CGFloat((promise.fetchPromiseData.count - 1) * -180))
                        //                            .padding(.top, isCardSpread ? 30 : 0)
                        
                    }
                    
                }
                // 배경색
                .background(Color.primaryInvert.ignoresSafeArea(.all))
                // MARK: - 약속 추가 버튼
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 스크롤을 최대한 바깥으로 하기 위함
                .navigationDestination(isPresented: $widgetStore.isShowingDetailForWidget) {
                    if let promise = widgetStore.widgetPromise {
                        PromiseDetailView(promise: promise)
                            .environmentObject(widgetStore)
                    }
                }
                .onAppear {
                    Task {
                        try await promise.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
                    }
                }
                .refreshable {
                    Task {
                        try await promise.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
                    }
                }
                // MARK: - 약속 추가 버튼
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        // 약속 추가 버튼
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                animate.toggle()
                                isShownFullScreenCover.toggle()
                            }
                        
                            .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                                AddPromiseView(promiseViewModel: promise)
                            })
                        
                    }
                }
                
            }
            
        }
        
    }
    
    func promiseListCell(promise: Promise, color: Color, isTracking: Bool) -> some View {
        // MARK: - 카드 배경 이미지, 테두리
        ZStack {
            // 맵 버튼 그라데이션 색 선언
            let gradient = LinearGradient(gradient: Gradient(stops: [
                Gradient.Stop(color: Color(hex: 0xFF5747), location: 0.1),
                Gradient.Stop(color: Color(hex: 0xFF5747).opacity(0.5), location: 1.0)
            ]), startPoint: .topLeading, endPoint: .bottomTrailing)
            
            // 카드 배경색
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.25)
                .foregroundColor(.clear)
                .background(color)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            //                    .background(LinearGradient(gradient:  Gradient(colors: [Color.blue, Color.green]), startPoint: .top, endPoint: .bottom))
            //                  .shadow(color: .primary, radius: 10, x: 5, y: 5)
            //                    .overlay {
            //                        RoundedRectangle(cornerRadius: 20, style: .continuous)
            //                            .stroke(.white, lineWidth: 4)
            //                    }
            
            // MARK: - 테두리
            //                if isTracking {
            //                    Group {
            //                        RoundedRectangle(cornerRadius: 20, style: .continuous)
            //                            .frame(width: screenWidth, height: screenHeight * 0.6)
            //                        //                .foregroundStyle(LinearGradient(gradient: Gradient(colors:[.red,.orange,.yellow,.green,.blue,.purple,.pink]), startPoint: .top, endPoint: .bottom))
            //                            .foregroundStyle(LinearGradient(gradient: Gradient(colors: [.sand.opacity(0.4), .frame3, .frame3, .frame3.opacity(0.4)]), startPoint: .top, endPoint: .bottom))
            //                            .rotationEffect(.degrees(rotation))
            //                            .mask {
            //                                RoundedRectangle(cornerRadius: 20, style: .continuous)
            //                                    .stroke(lineWidth: 3) // 라인 두께
            //                                    .frame(width: (screenWidth * 0.9)-2, height: (screenHeight * 0.5)-2)
            //                            }
            //                    }
            //
            //                    .onAppear {
            //                        withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
            //                            rotation = 360
            //                        }
            //                    }
            //                }
            VStack(alignment: .leading) {
                // MARK: - 약속 제목, 맵 버튼
                HStack {
                    Text(promise.promiseTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primaryInvert)
                    Spacer()
                    if isTracking {
                        NavigationLink {
                            FriendsMapView(promise: promise)
                        } label: {
                            ZStack {
                                // 맵 아이콘 배경색
                                
                                RoundedRectangle(cornerRadius: 20, style: .circular)
                                    .frame(width: 90, height: 34)
                                    .foregroundColor(.clear)
                                    .background(gradient)
                                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                                // 맵 아이콘 태두리
                                HStack {
                                    Image(systemName: "map.fill")
                                        .fontWeight(.bold)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .font(.headline)
                                        .foregroundColor(.primaryInvert)
                                    Text("LIVE")
                                        .fontWeight(.bold)
                                        .font(.headline)
                                        .foregroundStyle(.primaryInvert)
                                        .padding(.leading, -3)
                                }
                            } // ZStack
                            //                        .offset(y: isTracking ? -40 : 0)
                        }
                        .padding(.trailing, -5)
                        .symbolEffect(.pulse.byLayer, options: .repeating, isActive: isTracking)
                    }
                    
                    
                    // 추적중인 약속만 지도뷰 이동 가능
                    //                        if isTracking {
                    //                            NavigationLink {
                    //                                FriendsMapView(promise: promise)
                    //                            } label: {
                    //                                ZStack {
                    //                                    // 맵 아이콘 배경색
                    //
                    //                                    RoundedRectangle(cornerRadius: 60, style: .circular)
                    //                                        .frame(width: 80, height: 40)
                    //                                        .foregroundColor(.clear)
                    //                                        .background(gradient)
                    //                                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    //                                    // 맵 아이콘 태두리
                    //                                    HStack {
                    //                                        Image(systemName: "map.fill")
                    //                                            .fontWeight(.bold)
                    //                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    //                                            .font(.headline)
                    //                                            .foregroundColor(.primaryInvert)
                    //                                        Text("보기")
                    //                                            .fontWeight(.bold)
                    //                                            .font(.headline)
                    //                                            .foregroundStyle(.primaryInvert)
                    //                                    }
                    //                                } // ZStack
                    //                                //                        .offset(y: isTracking ? -40 : 0)
                    //                            }
                    //                            .symbolEffect(.pulse.byLayer, options: .repeating, isActive: isTracking)
                    //                        }
                }
                
                .padding(.vertical, 10)
                
                Group {
                    // MARK: - 장소, 시간
                    Group {
                        HStack {
                            Image(systemName: "pin")
                            Text("\(promise.destination)")
                        }
                        /// 저장된 promiseDate값을 Date 타입으로 변환
                        let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                        
                        HStack {
                            Image(systemName: "clock")
                            Text("\(formatDate(date: datePromise))")
                        }
                        .padding(.bottom, 10)
                    }
                    .font(.callout)
                    .fontWeight(.semibold)
                    
                    
                    //                        Rectangle()
                    //                            .background(Color.primaryInvert)
                    //                            .frame(height: 1).opacity(0.3)
                    
                    // MARK: - 참여자 목록, 벌금
                    
                    HStack(spacing: -12) {
                        
                        ForEach(locationStore.locationParticipantDatas) { user in
                            ProfileImageView(imageString: user.imageString, size: .xSmall)
                                .padding(1)
                                .background(.primaryInvert, in: Circle())
                            // 프사 원 테두리
                                .background(
                                    Circle()
                                        .stroke(.primary, lineWidth: 0.1)
                                )
                        }
                        //                        ProfileImageView(imageString: userImageString, size: .xSmall)
                        //                        .offset(x: -10, y: 0)
                        
                        Spacer()
                        Text("\(promise.penalty)원")
                            .fontWeight(.semibold)
                            .font(.title3)
                            .foregroundStyle(Color.primaryInvert)
                        // TODO: - promise.penalty 데이터 연결
                        
                        
                        //                    Text("\(promise.participantIdArray.count)명")
                        //                        .font(.callout)
                        //                        .fontWeight(.semibold)
                        //                        .foregroundColor(.primaryInvert)
                    }
                    .padding(.vertical, 15)
                    
                }
                .foregroundStyle(Color.primaryInvert)
                .fontWeight(.semibold)
                
                // 참여자의 ID를 통해 참여자 정보 가져오기
            }
            .padding(.horizontal, 20)
            .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
                .foregroundColor(.primary)
                .opacity(isTracking ? 0: 0.1)
                .shadow(color: .black, radius: 20, x: 1, y: 1)
        )
        //        .opacity(isTracking ? 1 : 0.5)
        
        .onAppear {
            Task {
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
            }
        }
    }
}
    


    // MARK: - 시간 형식변환 함수
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR") // 한글로 표시
        dateFormatter.dateFormat = "MM월 dd일 (E) a h:mm" // 원하는 날짜 형식으로 포맷팅
        return dateFormatter.string(from: date)
    }
    
    #Preview {
        HomeMainView(user: User.sampleData)
    }

extension Color {
    init(hex: UInt, opacity: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex & 0xFF0000) >> 16) / 255.0,
            green: Double((hex & 0x00FF00) >> 8) / 255.0,
            blue: Double(hex & 0x0000FF) / 255.0,
            opacity: opacity
        )
    }
}
