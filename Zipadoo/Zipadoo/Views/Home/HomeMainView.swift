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
    
    @StateObject private var loginUser: UserStore = UserStore()
    @StateObject private var promise: PromiseViewModel = PromiseViewModel()
    
    @State private var isShownFullScreenCover: Bool = false
    
    // 약속의 갯수 확인
    @State private var userPromiseArray: [Promise] = []
    // 상단 탭바 인덱스
    @State private var tabIndex = 0 
    var body: some View {
        NavigationStack {
            VStack {
                
                // MARK: - 상단 슬라이딩 탭
                SlidingTabView(selection: $tabIndex, tabs:
                                ["예정된 약속", "종료된 약속"], animation: .easeInOut,
                               activeAccentColor: .zipadoo, selectionBarColor: . zipadoo)
                Spacer()
                if tabIndex == 0 {
                    PromiseListView
                } else if tabIndex == 1 {
                    PastPromiseView()
                }
                
                Spacer()
//                Picker("Segmented Picker", selection: $selectedSegmentIndex) {
//                    Text("예정된 약속").tag(0)
//                    Text("종료된 약속").tag(1)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//                
//                if selectedSegmentIndex == 0 {
//                                  PromiseListView // 앞으로의 약속
//                              } else if selectedSegmentIndex == 1 {
//                                  PastPromiseView() // 지난 약속
//                              }
//                
            }  
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShownFullScreenCover.toggle()
                    } label: {
                        Image(systemName: "calendar.badge.plus")
                            .foregroundColor(.primary)
                            .fontWeight(.semibold)
                    }
                    .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                        AddPromiseView()
                    })
                    
                }
                
            }
            .refreshable {
                Task {
                    try await promise.fetchData()
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
    private var PromiseListView: some View {
        ScrollView {
            VStack {
                if let loginUserID = loginUser.currentUser?.id {
                    let filteredPromises = promise.promiseViewModel.filter { promise in
                        return loginUserID == promise.makingUserID
                    }
                    
                    if filteredPromises.isEmpty {
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
                        ForEach(filteredPromises, id: \.self) { promise in
                            NavigationLink {
                                PromiseDetailView(promise: promise)
                            } label: {
                                VStack(alignment: .leading) {
                                    
                                    // MARK: - 약속 제목, 맵 버튼
                                    HStack {
                                        Text(promise.promiseTitle)
                                            .font(.title)
                                            .fontWeight(.bold)
                                        
                                        Spacer()
                                        
                                        NavigationLink {
                                            FriendsMapView(promise: promise)
                                        } label: {
                                            Image(systemName: "map.fill")
                                                .fontWeight(.bold)
                                                .foregroundStyle(Color.primary)
                                                .colorInvert()
                                                .padding(8)
                                                .background(Color.primary)
                                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 10)
                                                        .shadow(color: .primary, radius: 1, x: 1, y: 1)
                                                        .opacity(0.3)
                                                    //
                                                )
                                        }
                                    }
                                    .padding(.vertical, 15)
                                    // MARK: - 장소, 시간
                                    Group {
                                        HStack {
                                            Image(systemName: "pin")
                                            Text("\(promise.destination)")
                                        }
                                        .padding(.bottom, 5)
                                        
                                        /// 저장된 promiseDate값을 Date 타입으로 변환
                                        let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                                        
                                        HStack {
                                            Image(systemName: "clock")
                                            Text("\(formatDate(date: datePromise))")
                                        }
                                        .padding(.bottom, 25)
                                        
                                        // MARK: - 도착지까지 거리, 벌금
                                        HStack {
                                            Text("6km")
                                            Spacer()
                                            
                                            Text("5,000원")
                                                .fontWeight(.semibold)
                                                .font(.title3)
                                        }
                                        .padding(.vertical, 10)
                                        
                                    }
                                    .font(.callout)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.primary).opacity(0.5)
                                    // 참여자의 ID를 통해 참여자 정보 가져오기
                                }
                                // MARK: - 약속 테두리
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
                            
                        }
                    }
                    
                }
                
            } // VStack
            // MARK: - 약속 추가 버튼
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity) // 스크롤을 최대한 바깥으로 하기 위함
          
            // toolbar
            .onAppear {
                print(Date().timeIntervalSince1970)
                var calendar = Calendar.current
                calendar.timeZone = NSTimeZone.local
                let encoder = JSONEncoder()
                
                var widgetDatas: [WidgetData] = []
                
                for promise in promise.promiseViewModel {
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
      
    }

    // ScrollView
    
    //            .ignoresSafeArea(.all)
    
}
//                .refreshable {
//                    Task {
//                        try await promise.promiseViewModel.fetchPromise()
//                    }
//                }
//                .onAppear {
//                    Task {
//                        try await promise.promiseViewModel.fetchPromise()
//                    }
//                }
//    }
//}

// MARK: - 시간 형식변환 함수
func formatDate(date: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_KR") // 한글로 표시
    dateFormatter.dateFormat = "MM월 dd일 (E) a h:mm" // 원하는 날짜 형식으로 포맷팅
    return dateFormatter.string(from: date)
}

#Preview {
    HomeMainView()
}
