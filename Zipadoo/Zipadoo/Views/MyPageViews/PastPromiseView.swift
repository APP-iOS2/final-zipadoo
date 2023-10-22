//
//  PastPromiseView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

import SwiftUI
import WidgetKit

struct PastPromiseView: View {
    @EnvironmentObject var promise: PromiseViewModel
    @State private var isShownFullScreenCover: Bool = false
    
    let currentUser = AuthStore.shared.currentUser
    
    var body: some View {
        NavigationStack {
            if let loginUserID = currentUser?.id {
                ScrollView {
                    // 약속 배열 값 존재하는지 확인.
                    if promise.fetchPastPromiseData.isEmpty {
                        Text("지난 약속 내역이 없습니다.")
                        
                    } else {
                        VStack {
                            ForEach(promise.fetchPastPromiseData) { promise in
                                NavigationLink {
                                    // 도착정보 보여주기
                                    ArriveResultView(promise: promise)

                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(promise.promiseTitle)
                                                .font(.title2)
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                        }
                                        .padding(.bottom, 8)
                                        
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
                                            .padding(.bottom, 8)
                                            
                                            HStack {
                                                Text("\(promise.participantIdArray.count)인")
                                                Spacer()
                                                
                                                Text("\(promise.penalty)")
                                                    .fontWeight(.semibold)
//                                                    .font(.title3)
                                            }
//                                            .padding(.bottom, 10)
                                            
                                        }
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary).opacity(0.5)
                                        // 참여자의 ID를 통해 참여자 정보 가져오기
                                    }
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 20, trailing: 20))
                                    .overlay(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.zipadoo)
                                                .opacity(0.1)
                                                .shadow(color: .zipadoo, radius: 10, x: 0, y: 5)
                                        }
                                        
                                    )
                                    .foregroundStyle(Color.primary)
                                    
                                }
                                .padding(10) 
                            }
                        }
                    }
                }
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
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                //                    .toolbar {
                //                        ToolbarItem(placement: .topBarTrailing) {
                //                            Button {
                //                                // 삭제 코드 추가
                //                            } label: {
                //                               //
                //                            }
                //                            .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                //                                AddPromiseView()
                //                            })
                //                        }
                //                    }
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
            }
        }
    }
}

#Preview {
    NavigationStack {
        PastPromiseView()
            .environmentObject(PromiseViewModel())
    }
}
