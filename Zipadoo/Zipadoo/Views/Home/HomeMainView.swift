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
    
    // 더미데이터
    private let dataArray: [Promise] = [promise, promise1]
    
    var body: some View {
        NavigationStack {
            // 약속 배열 값 존재하는지 확인.
            if dataArray.isEmpty {
                Text("현재 약속이 1도 없어요!")
            } else {
                ScrollView {
                    ForEach(dataArray, id: \.self) { promise in
                        NavigationLink {
                            PromiseDetailView()
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(promise.promiseTitle)
                                        .font(.title)
                                    
                                    Spacer()
                                    
                                    Text("위치 공유 중")
                                        .foregroundStyle(Color.white)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 5)
                                        .background(Color.gray)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.black, lineWidth: 1)
                                        )
                                }
                                
                                Text("약속 장소 : \(promise.destination)")
                                
                                /// 저장된 promiseDate값을 Date 타입으로 변환
                                let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                                Text("약속 시간 : \(promise.promiseDate)")
                                
                                // 참여자의 ID를 통해 참여자 정보 가져오기
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                            .foregroundStyle(Color.black)
                        }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            AddPromiseView()
                        } label: {
                            Text("약속 추가")
                        }
                    }
                }
                .onAppear {
                    print(Date().timeIntervalSince1970)
                    var calendar = Calendar.current
                    calendar.timeZone = NSTimeZone.local
                    let encoder = JSONEncoder()
                    
                    var widgetDatas: [WidgetData] = []
                    
                    for promise in dataArray {
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
    HomeMainView()
}
