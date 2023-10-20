//
//  HomeMainView.swift
//  Zipadoo
//  약속 리스트 뷰
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI
import WidgetKit

struct HomeMainView: View {
    @EnvironmentObject var promise: PromiseViewModel
    @EnvironmentObject var widgetStore: WidgetStore
    let user: User?
    
    @State private var isShownFullScreenCover: Bool = false
    
    // 약속의 갯수 확인
    //    @State private var userPromiseArray: [Promise] = []
    // 상단 탭바 인덱스
    @State private var tabIndex = 0
    var body: some View {
        NavigationStack {
            // 예정된 약속 리스트
            if let loginUserID = user?.id {
                ScrollView {
                    // 예정중이거나 추적중인 약속이 하나도 없으면
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
                        
                    } else {
                        // 추적중
                        ForEach(promise.fetchTrackingPromiseData) { promise in
                            NavigationLink {
                                PromiseDetailView(promise: promise)
                                
                            } label: {
                                promiseListCell(promise: promise, color: .red)
                            }
                            
                        }
                        ForEach(promise.fetchPromiseData) { promise in
                            NavigationLink {
                                PromiseDetailView(promise: promise)
                            } label: {
                                promiseListCell(promise: promise, color: .primary)
                            }
                            
                            .padding()
                            
                        }
                    }
                    
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
                                .environmentObject(promise)
                        })
                        
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity) // 스크롤을 최대한 바깥으로 하기 위함
                .onAppear {
                    Task {
                        try await promise.fetchData(userId: loginUserID)
                    }
                }
                .refreshable {
                    Task {
                        try await promise.fetchData(userId: loginUserID)
                    }
                }
                .navigationDestination(isPresented: $widgetStore.isShowingDetailForWidget) {
                    PromiseDetailView(promise: widgetStore.widgetPromise ??
                                      Promise(id: "", makingUserID: "", promiseTitle: "", promiseDate: 0.0, destination: "", address: "", latitude: 0.0, longitude: 0.0, participantIdArray: [""], checkDoublePromise: false, locationIdArray: [""]))
                }
            }
        }
    }
    
    func promiseListCell(promise: Promise, color: Color) -> some View {
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
                    .foregroundColor(color)
                    .opacity(0.05)
                    .shadow(color: .primary, radius: 10, x: 5, y: 5)
            }
            
        )
        .foregroundStyle(Color.primary)
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
        .environmentObject(AlertStore())
        .environmentObject(PromiseViewModel())
}
