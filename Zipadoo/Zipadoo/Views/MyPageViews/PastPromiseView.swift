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
    
    /// 페이지마다 나올 첫 번쨰 인덱스
    var startIndex: Int {
        print("\((promise.selectedPage - 1) * 10)")
        return (promise.selectedPage - 1) * 10
    }
    /// 페이지마다 나올 마지막 인덱스
    var endIndex: Int {
        // 마지막페이지 누르면 남은거 다 가져오기
        if promise.selectedPage == promise.pastPromisePage {
            print("\(promise.fetchPastPromiseData.count)")
            return promise.fetchPastPromiseData.count
        } else {
            print("\((promise.selectedPage - 1) * 10 + 10)")
            return (promise.selectedPage - 1) * 10 + 10
        }
    }
    
    var body: some View {
        VStack {
            if promise.isLoading == false {
                VStack {
                    // 약속 배열 값 존재하는지 확인.
                    if promise.fetchPastPromiseData.isEmpty {
                        Text("지난 약속 내역이 없습니다")
                            .foregroundStyle(.secondary)
                        
                    } else {
                        ScrollView {
                            ForEach(promise.fetchPastPromiseData[startIndex ..< endIndex]) { promise in
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
                        // 스크롤뷰 밖 버튼
                        HStack {
                            ForEach(1...promise.pastPromisePage, id: \.self) { page in
                                Button {
                                    promise.selectedPage = page
                                    
                                } label: {
                                    ZStack {
                                        if page == promise.selectedPage {
                                            Circle()
                                                .foregroundStyle(.sand)
                                        }
                                        Text("\(page)")
                                    }
                                    .frame(width: 20, height: 20)

                                }
                                .disabled(page == promise.selectedPage) // 이미선택된 페이지는 disabled
                                .foregroundColor(page == promise.selectedPage ? .cider : .secondary)
//                                    .padding(.trailing, 5)
                            }
                        }
                    }
                }
                
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
        .onAppear {
            Task {
                try await promise.fetchData(userId: currentUser?.id ?? "no id")
            }
        }
        .refreshable {
            Task {
                try await promise.fetchData(userId: currentUser?.id ?? "no id")
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationStack {
        PastPromiseView()
            .environmentObject(PromiseViewModel())
    }
}
