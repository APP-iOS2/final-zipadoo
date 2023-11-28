//
//  HomeMainView.swift
//  Zipadoo
//  약속 리스트 뷰
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI
import SlidingTabView

// MARK: - 홈 메인 뷰
struct HomeMainView: View {
    @EnvironmentObject var promise: PromiseViewModel // PromiseViewModel 클래스 및 데이터를 공유하는 promise 선언
    @EnvironmentObject var widgetStore: WidgetStore // WidgetStore 클래스 및 데이터를 공유하는 promise 선언
    
    /// 풀스크린커버를 동작시킬 Bool 데이터값
    @State private var isShownFullScreenCover: Bool = false
    
    /// 약속 카드 테두리 색 모션회전 데이터값
    @State private var rotation: CGFloat = 0.0

    /// 선택한 카드 퍼뜨리기 애니메이션 Bool 데이터값
    @State private var isCardSpread: Bool = false
    
    let user: User? // User 형식을 받는 user 선언
    
    // 기기별 화면크기 선언
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - HomeMainView body
    var body: some View {
        NavigationStack {
            // user의 id가 있는지 확인이 되면 표시
            if let _ = user?.id {
                ScrollView(.vertical, showsIndicators: false) {
                    // 추적중인 약속과 예정인 약속의 배열이 비어있으면 표시
                    if promise.fetchTrackingPromiseData.isEmpty && promise.fetchPromiseData.isEmpty {
                        // 두더지 이미지와 함께 약속을 생성하라는 Text 띄움
                        VStack {
                            Image("Dothez")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150)
                            
                            Text("약속이 없어요\n 약속을 만들어 보세요!")
                                .multilineTextAlignment(.center)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.secondary)
                                .padding()
                        }
                        .padding(.top, 100)
                        .padding(.horizontal, 20)
                    } else {
                    // MARK: - 추적중 약속 리스트가 있을 때 보이도록 함
                    if !promise.fetchTrackingPromiseData.isEmpty {
                        HStack {
                            Text("진행중인 약속")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .font(.title2)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.bottom, -10)
                    }
                    // 추적중 약속 리스트
                    ForEach(promise.fetchTrackingPromiseData) { promise in
                        // 해당 약속에 대한 PromiseDetailMapView로 이동
                        NavigationLink {
                            PromiseDetailMapView(promise: promise)
                                .environmentObject(self.promise)
                        } label: {
                            PromiseListCell(promise: promise, color: .mocha, isTracking: true)
                        }
                        .padding(.vertical, 15) // 리스트 패딩차이 조절용
                    }
                    
                    // MARK: - 예정된 약속 리스트가 있을 때 보이도록 함
                    if !promise.fetchPromiseData.isEmpty {
                        HStack {
                            Text("예정된 약속")
                                .foregroundColor(.primary)
                                .fontWeight(.semibold)
                                .font(.title2)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                        .padding(.top, 10)
                        .padding(.bottom, -10)
                    }
                    // 예정된 약속 리스트
                    ForEach(promise.fetchPromiseData.indices, id: \.self) { index in // indices : 유효한 범위(0..<fetchPromiseData.last)
                        NavigationLink {
                            PromiseDetailView(promise: promise.fetchPromiseData[index])
                        } label: {
                            PromiseListCell(promise: promise.fetchPromiseData[index], color: .mochaInvert, isTracking: false)
                            .overlay {
                                Rectangle()
                                    .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
                                    .foregroundColor(.black.opacity(isCardSpread ? 0 : 0.001))
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.35)) {
                                            // 카드 스프레드 애니메이션 동작
                                            isCardSpread.toggle()
                                        }
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                            withAnimation(.easeInOut(duration: 0.35)) {
                                                // 카드 스프레드 애니메이션 끔
                                                isCardSpread = false
                                            }
                                        }
                                    }
                            }
                            .offset(y: isCardSpread ? 0 : CGFloat(index) * -120)
                            .padding()
                        }
                    }
                }
                }
                .background(Color.primaryInvert.ignoresSafeArea(.all)) // 배경색
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 스크롤을 최대한 바깥으로 하기 위함
                
                // 위젯을 클릭했을 때의 동작
                .navigationDestination(isPresented: $widgetStore.isShowingDetailForWidget) { // widgetStore.isShowingDetailForWidget에 따라 네비게이션 대상을 설정
                    
                    // widgetStore.widgetPromise가 있을 경우, 해당 promise의 PromiseDetailMapView로 이동함
                    if let promise = widgetStore.widgetPromise {
                        PromiseDetailMapView(promise: promise)
                            .environmentObject(widgetStore)
                    }
                }
                
                // 뷰가 나타날 때 fetchData를 실행
                .onAppear {
                    Task {
                        try await promise.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
                    }
                }
                
                // 새로고침할 때 fetchData를 실행
                .refreshable {
                    Task {
                        try await promise.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
                    }
                }
                
                // 상단 툴바 설정
                .toolbar {
                    // MARK: - 약속 추가 버튼
                    ToolbarItem(placement: .topBarTrailing) {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                            .onTapGesture {
                                // 약속등록 버튼 바운스 실행
//                                animate.toggle()
                                // 풀스크린커버 실행
                                isShownFullScreenCover.toggle()
                            }
                            // 약속 등록뷰 올라옴
                            .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                                AddPromiseView(promiseViewModel: promise)
                            })
                    }
                    // MARK: - 지파두 마크
                    ToolbarItem(placement: .topBarLeading) {
                        Image("zipadooMark")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                    }
                }
            }
        }
    }
}

// MARK: - 약속 정보 카드뷰
struct PromiseListCell: View {
    var promise: Promise
    var color: Color
    
    /// 추적 중을 나타내는 Bool값
    var isTracking: Bool
    
    /// 데이터 로딩 상태를 나타내는 불값
    @State private var isLoading: Bool = true
    
    /// 참여자들의 프로필 String 배열
    @State private var participantImageArray: [String] = []
    
    // 기기별 화면크기 선언
    private let screenWidth = UIScreen.main.bounds.size.width
    private let screenHeight = UIScreen.main.bounds.size.height
    
    // MARK: - PromiseListCell body
    var body: some View {
        ZStack {
           // 카드 배경색
           RoundedRectangle(cornerRadius: 10, style: .continuous)
               .frame(width: screenWidth * 0.9, height: screenHeight * 0.25)
               .foregroundColor(.clear)
               .background(color)
               .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            // MARK: - 약속 정보
           VStack(alignment: .leading) {
               // MARK: - 약속 제목, 맵 버튼
               promiseHeader(promise: promise, isTracking: isTracking)
                   .padding(.vertical, 10)
               // MARK: - 장소, 시간, 참여자목록, 벌금
               Group {
                   // 장소, 시간
                   Group {
                       HStack {
                           Image(systemName: "pin")
                               .font(.footnote)
                           Text("\(promise.destination)")
                       }
                       /// 저장된 promiseDate값을 Date 타입으로 변환
                       let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                       
                       HStack {
                           Image(systemName: "clock")
                               .font(.footnote)
                           Text("\(formatDate(date: datePromise))")
                       }
                       .padding(.bottom, 10)
                   }
                   .font(.callout)
                   .fontWeight(.semibold)
                   
                   // 참여자 목록, 벌금
                   if !isLoading {
                       HStack(spacing: -12) {
                           // 참여자 목록
                           ForEach(participantImageArray, id: \.self) { imageString in
                               ProfileImageView(imageString: imageString, size: .xSmall)
                                   .padding(1)
                                   .background(.primaryInvert, in: Circle())
                           }
                           
                           Spacer()
                           
                           // 벌금
                           Text("\(promise.penalty)원")
                               .fontWeight(.semibold)
                               .font(.title3)
                               .foregroundStyle(isTracking ? Color.primaryInvert : .mocha)
                       }
                       .padding(.vertical, 15)
                   }
               }
               .foregroundStyle(isTracking ? Color.primaryInvert : .mocha)
               .fontWeight(.semibold)
           }
           .padding(.horizontal, 20)
           .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
       }
       .overlay(
           RoundedRectangle(cornerRadius: 10)
               .frame(width: screenWidth * 0.9, height: screenHeight * 0.25 )
               .foregroundColor(.primary)
               .opacity(isTracking ? 0: 0.05) // 0.1 다소 어두워서 0.05로 더 밝게처리
               .shadow(color: .black, radius: 20, x: 1, y: 1)
       )
        
        // 참여자의 ID를 통해 참여자 프로필사진 가져오기
       .onAppear {
           Task {
               participantImageArray = []
               for id in promise.participantIdArray {
                   let imageString = try await UserStore.fetchUser(userId: id)?.profileImageString ?? "- no image -"
                   participantImageArray.append(imageString)
               }
               isLoading = false
           }
       }
    }
    
    // MARK: - some View(promiseHeader)
    private func promiseHeader(promise: Promise, isTracking: Bool) -> some View {
        HStack {
            Text(promise.promiseTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isTracking ? .primaryInvert : .mocha)
            
            Spacer()
            // 추적 중인 약속이면 PromiseDetailMapView로 이동
            if isTracking {
                NavigationLink {
                    PromiseDetailMapView(promise: promise)
                } label: {
                    ZStack {
                        // 맵 아이콘 배경색
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .frame(width: 90, height: 40)
                            .foregroundColor(.clear)
                            .background(Color.red)
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
                    }
                }
                .padding(.trailing, -5)
                .symbolEffect(.pulse.byLayer, options: .repeating, isActive: isTracking)
            }
        }
    }
}

// MARK: - Color extension
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

// MARK: - 시간 형식변환 함수
func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR") // 한글로 표시
    dateFormatter.dateFormat = "MM월 dd일 (E) a h:mm" // 원하는 날짜 형식으로 포맷팅
    return dateFormatter.string(from: date)
}

// MARK: - 프리뷰 크래시로 인해 프리뷰코드 주석처리
/* #Preview {
    HomeMainView(user: User.sampleData)
} */
