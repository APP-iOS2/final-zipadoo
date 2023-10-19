//
//  HomeMainView.swift
//  Zipadoo
//  약속 리스트 뷰
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI
import WidgetKit
import SlidingTabView

struct HomeMainView: View {
    
    let user: User?

    //    @StateObject private var loginUser: UserStore = UserStore()

    
    @ObservedObject private var locationStore: LocationStore = LocationStore()
    
    @StateObject var promise: PromiseViewModel = PromiseViewModel()
    
    @State private var isShownFullScreenCover: Bool = false
    
    // 약속의 갯수 확인
    //    @State private var userPromiseArray: [Promise] = []
    // 상단 탭바 인덱스
    @State private var tabIndex = 0
    
    // 약속 카드 테두리 색 모션회전
    @State var rotation: CGFloat = 0.0
    
    // 약속등록 버튼 바운스
    @State private var animate = false
    
    // 참여유저 프로필 이미지
    var userImageString: String {
            user?.profileImageString ?? "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
        }

    
    // 기기별 화면크기 선언
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height

    
    var body: some View {
        NavigationStack {
            VStack {
                // 예정된 약속 리스트
                ScrollView(showsIndicators: false) {
                    if let loginUserID = user?.id {
                        // 내가만든 약속 또는 참여하는 약속 불러오기
                        let filteredPromises = promise.fetchPromiseData.filter { promise in
                            return loginUserID == promise.makingUserID || promise.participantIdArray.contains(loginUserID)
                            
                        }
                        let filteredTrackingPromises = promise.fetchTrackingPromiseData.filter { promise in
                            return loginUserID == promise.makingUserID || promise.participantIdArray.contains(loginUserID)
                        }
                        // 예정중이거나 추적중인 약속이 하나도 없으면
                        if filteredTrackingPromises.isEmpty && filteredPromises.isEmpty {
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
                            
                        } else {
                            // 추적중
                            ForEach(filteredTrackingPromises.indices, id: \.self) { index in
                                let promise = filteredTrackingPromises[index]
                                NavigationLink {
                                    PromiseDetailView(promise: promise)
                                } label: {

                                    promiseListCell(promise: promise, color: .red, isTracking: true)

                                }
//                                .offset(y: CGFloat(index) * -50) // 이 값 조정
                            }

                            ForEach(filteredPromises.indices, id: \.self) { index in
                                let promise = filteredPromises[index]
                                NavigationLink {
                                    PromiseDetailView(promise: promise)
                                } label: {
                                    promiseListCell(promise: promise, color: .primary, isTracking: false)
                                }
//                                .offset(y: CGFloat(index) * -50) // 이 값 조정
                            }
                        }
                        
                    }
                    
                } // VStack
            }
            
            // MARK: - 약속 추가 버튼
            
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 스크롤을 최대한 바깥으로 하기 위함
            // toolbar
            .onAppear {
                
                print(Date().timeIntervalSince1970)
                var calendar = Calendar.current
                calendar.timeZone = NSTimeZone.local
                let encoder = JSONEncoder()
                
                var widgetDatas: [WidgetData] = []
                
                for promise in promise.fetchPromiseData {
                    let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
                    let promiseDateComponents = calendar.dateComponents([.year, .month, .day], from: promiseDate)
                    let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
                    
                    if promiseDateComponents == todayComponents {
                        // TODO: 도착 인원 수 파베 연동 후 테스트하기. 지금은 0으로!
                        let data = WidgetData(title: promise.promiseTitle, time: promise.promiseDate, place: promise.destination, arrivalMember: 0)
                        widgetDatas.append(data)
                    }
                }
                
                do {
                    let encodedData = try encoder.encode(widgetDatas)
                    
                    UserDefaults.shared.set(encodedData, forKey: "todayPromises")
                    
                    WidgetCenter.shared.reloadTimelines(ofKind: "ZipadooWidget")
                } catch {
                    print("Failed to encode Promise:", error)
                }
            }
            .onAppear {
                Task {
                    try await promise.fetchData()
                }
            }
            .refreshable {
                Task {
                    try await promise.fetchData()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {

                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .symbolEffect(.bounce, value: animate)

                            .onTapGesture {
                                animate.toggle()
                                isShownFullScreenCover.toggle()
                            }

                    .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                        AddPromiseView(promiseViewModel: promise)
                    })
                    
                }
            }
            
            //            .ignoresSafeArea(.all)
            
            //            var widgetDatas: [WidgetData] = []
            //
            //            for promise in promise.promiseViewModel {
            //                let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
            //                let promiseDateComponents = calendar.dateComponents([.year, .month, .day], from: promiseDate)
            //                let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            //
            //                if promiseDateComponents == todayComponents {
            //                    // TODO: 도착 인원 수 파베 연동 후 테스트하기. 지금은 0으로!
            //                    let data = WidgetData(title: promise.promiseTitle, time: promise.promiseDate, place: promise.destination, arrivalMember: 0)
            //                    widgetDatas.append(data)
            //                }
            //            }
            
            //            do {
            //                let encodedData = try encoder.encode(widgetDatas)
            //
            //                UserDefaults.shared.set(encodedData, forKey: "todayPromises")
            //
            //                WidgetCenter.shared.reloadTimelines(ofKind: "ZipadooWidget")
            //            } catch {
            //                print("Failed to encode Promise:", error)
            //            }
        }
        
    }

    func promiseListCell(promise: Promise, color: Color, isTracking: Bool) -> some View {
        // MARK: - 카드 배경 이미지, 테두리
        ZStack {
            // 홈 뷰배경색
       
             // 카드 배경색
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .frame(width: 300, height: 400)
                        .foregroundColor(.lusciousRed)
                        .shadow(radius: 0.5, x: 1.5, y: 1.5)
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .foregroundColor(.white)
//                .blur(radius: 50)
//                .frame(width: 330, height: 330)

//            // MARK: - 테두리
//            if isTracking {
//                Group {
//                    RoundedRectangle(cornerRadius: 20, style: .continuous)
//                        .frame(width: 420, height: 200)
//                    //                .foregroundStyle(LinearGradient(gradient: Gradient(colors:[.red,.orange,.yellow,.green,.blue,.purple,.pink]), startPoint: .top, endPoint: .bottom))
//                        .foregroundStyle(LinearGradient(gradient: Gradient(colors:[.cardFrame.opacity(1),.cardFrame,.cardFrame,.cardFrame.opacity(1)]), startPoint: .top, endPoint: .bottom))
//                        .rotationEffect(.degrees(rotation))
//                        .mask {
//                            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                                .stroke(lineWidth: 6) // 라인 두께
//                                .frame(width: 338, height: 258)
//                        }
//                }
//                // MARK: - 약속 테두리
//                .onAppear {
//                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
//                        rotation = 360
//                    }
//                }
//            }

            VStack(alignment: .leading) {
                // MARK: - 약속 제목, 맵 버튼
                HStack {
                    Text(promise.promiseTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.withe)
                    Spacer()

                    NavigationLink {
                        FriendsMapView(promise: promise)
                    } label: {
                        ZStack {
                            // 맵 아이콘 배경색
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .frame(width: 40, height: 40)
                                .foregroundColor(.primary)
                            // 맵 아이콘 태두리
                            if isTracking {
                                Group {
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .frame(width: 30, height: 40)
                                        .foregroundStyle(LinearGradient(gradient: Gradient(colors:[.nickel.opacity(0.5), .primaryInvert,.silver, .primaryInvert.opacity(1)]), startPoint: .top, endPoint: .bottom))
                                        .rotationEffect(.degrees(rotation))
                                        .mask {
                                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                                .stroke(lineWidth: 1) // 라인 두께
                                                .frame(width: 39, height: 39)
                                        }
                                }
                                .onAppear {
                                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                                        rotation = 360
                                    }
                                }
                            }
// 맵 아이콘 색
                            Image(systemName: "map.fill")
                                .fontWeight(.bold)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .font(.title2)
                                .foregroundColor(.primaryInvert)
   
                        } // ZStack
//                        .offset(y: isTracking ? -40 : 0)
                    }
                    .symbolEffect(.pulse.byLayer, options: .repeating, isActive: isTracking)
                }
                
                .padding(.vertical, 30)
                .padding(.bottom, 40)
                
                Spacer()
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
                    .padding(.bottom, 25)
               
                   Rectangle()
                        .background(Color.primaryInvert)
                        .frame(height: 2)
                        
                    // MARK: - 도착지까지 거리, 벌금
                       
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
                        // TODO: - promise.selectdValue 데이터 연결
                        Text("0원")
    //                    Text("\(promise.selectedValue)")
                            .fontWeight(.semibold)
                            .font(.title3)
                            .foregroundStyle(Color.primaryInvert)
    //                    Text("\(promise.participantIdArray.count)명")
    //                        .font(.callout)
    //                        .fontWeight(.semibold)
    //                        .foregroundColor(.primaryInvert)
                    }
                    .padding(.vertical, 20)
                }
                .foregroundStyle(Color.primaryInvert)
                .fontWeight(.semibold)
                // 참여자의 ID를 통해 참여자 정보 가져오기
            }
            .padding(.horizontal, 20)
            .frame(width: 300, height: 400)
        }
//        .opacity(isTracking ? 1 : 0.5)
        .padding(20)
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
