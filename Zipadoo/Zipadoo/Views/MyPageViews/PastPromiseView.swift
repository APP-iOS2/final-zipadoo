//
//  PastPromiseView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

import SwiftUI

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
                        
                    }
                    else {
                        VStack {
                            ForEach(promise.fetchPastPromiseData) { promise in
                                NavigationLink {
                                    // 도착정보 보여주기
                                    ArriveResultView(promise: promise)

                                } label: {
                                    VStack(alignment: .leading) {
                                        HStack {
                                            Text(promise.promiseTitle)
                                                .font(.title)
                                                .fontWeight(.bold)
                                            
                                            Spacer()
                                            
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
                                        .padding(.vertical, 10)
                                        
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
                                            .padding(.bottom, 20)
                                            
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
                                        .foregroundStyle(.primary).opacity(0.5)
                                        // 참여자의 ID를 통해 참여자 정보 가져오기
                                    }
                                    .padding()
                                    .overlay(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundColor(.zipadoo)
                                                .opacity(0.05)
                                                .shadow(color: .zipadoo, radius: 10, x: 5, y: 5)
                                        }
                                        
                                    )
                                    .foregroundStyle(Color.primary)
                                }
                                .padding()
                                
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
