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

//    @StateObject private var userStore: UserStore = UserStore()
    
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
    
    // 기기별 화면크기 선언
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    
    var body: some View {
        NavigationStack {
            // 예정된 약속 리스트
            if let _ = user?.id {
                ScrollView(.vertical, showsIndicators: false) {
                    if promise.fetchTrackingPromiseData.isEmpty && promise.fetchPromiseData.isEmpty {
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
                        // 추적중
                        if !promise.fetchTrackingPromiseData.isEmpty { // 리스트가 있을 때 보이도록 함
                            HStack {
                                Text("진행중인 약속")
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .font(.title3)
                                    .padding(.horizontal, 35)
                                Spacer()
                            }
                            .padding(.bottom, -10)
                            .padding(.top, 10)
                        }
                        
                        ForEach(promise.fetchTrackingPromiseData) { promise in
                            NavigationLink {
                                PromiseDetailMapView(promise: promise)
                                    .environmentObject(self.promise)
                            } label: {
                                PromiseListCell(promise: promise, color: .mocha, isTracking: true)
                            }
                            .padding(.vertical, 15) // 리스트 패딩차이 조절용
                            
                        }
                        
                        // 예정된약속
                        if !promise.fetchPromiseData.isEmpty { // 리스트가 있을 때 보이도록 함
                            HStack {
                                Text("예정된 약속")
                                    .foregroundColor(.primary)
                                    .fontWeight(.semibold)
                                    .font(.title3)
                                    .padding(.horizontal, 35)
                                Spacer()
                            }
                            .padding(.bottom, -10)
                        }
                        
                        ForEach(promise.fetchPromiseData.indices, id: \.self) { index in
                            PromiseListCell(promise: promise.fetchPromiseData[index], color: .color4, isTracking: false)
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
                        PromiseDetailMapView(promise: promise)
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

struct PromiseListCell: View {
    var promise: Promise
    var color: Color
    var isTracking: Bool
    
    @State var isLoading: Bool = true
    
    // 기기별 화면크기 선언
    let screenWidth = UIScreen.main.bounds.size.width
    let screenHeight = UIScreen.main.bounds.size.height
    /// 참여자들의 프로필 String 배열
    @State var participantImageArray: [String] = []
    
    var body: some View {
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

           VStack(alignment: .leading) {
               // MARK: - 약속 제목, 맵 버튼
               promiseHeader(promise: promise, isTracking: isTracking)
                   .padding(.vertical, 10)
               
               Group {
                   // MARK: - 장소, 시간
                   Group {
                       HStack {
                           Image(systemName: "pin")
                               .font(.footnote) // 아이콘이 너무 커서 좀더 작게함
                           Text("\(promise.destination)")
                       }
                       /// 저장된 promiseDate값을 Date 타입으로 변환
                       let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                       
                       HStack {
                           Image(systemName: "clock")
                               .font(.footnote) // 아이콘이 너무 커서 좀더 작게함
                           Text("\(formatDate(date: datePromise))")
                       }
                       .padding(.bottom, 10)
                   }
                   .font(.callout)
                   .fontWeight(.semibold)
                   
                   // MARK: - 참여자 목록, 벌금
                   if !isLoading {
                       HStack(spacing: -12) {
                           ForEach(participantImageArray, id: \.self) { imageString in
                               ProfileImageView(imageString: imageString, size: .xSmall)
                                   .padding(1)
                                   .background(.primaryInvert, in: Circle())
                               // 프사 원 테두리
                                   .background(
                                    Circle()
                                        .stroke(.primary, lineWidth: 0.1)
                                   )
                           }
                           //                        ProfileImageView(imageString: makinguser[0], size: .xSmall)
                           Spacer()
                           Text("\(promise.penalty)원")
                               .fontWeight(.semibold)
                               .font(.title3)
                               .foregroundStyle(isTracking ? Color.primaryInvert : .mocha)
                           // TODO: - promise.penalty 데이터 연결
                       }
                       .padding(.vertical, 15)
                   }
                   
               }
               .foregroundStyle(isTracking ? Color.primaryInvert : .mocha)
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
               .opacity(isTracking ? 0: 0.05) // 0.1 다소 어두워서 0.05로 더 밝게처리
               .shadow(color: .black, radius: 20, x: 1, y: 1)
       )
       
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
    
    private func promiseHeader(promise: Promise, isTracking: Bool) -> some View {
        HStack {
            Text(promise.promiseTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(isTracking ? .primaryInvert : .mocha)
            Spacer()
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
                    } // ZStack
                    //                        .offset(y: isTracking ? -40 : 0)
                }
                .padding(.trailing, -5)
                .symbolEffect(.pulse.byLayer, options: .repeating, isActive: isTracking)
            }
        }
    }
}
