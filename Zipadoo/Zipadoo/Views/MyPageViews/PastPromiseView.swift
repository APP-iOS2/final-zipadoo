//
//  PastPromiseView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

import SwiftUI

struct PastPromiseView: View {
    @EnvironmentObject var promise: PromiseViewModel
    
    // AuthStore에서 현재 사용자 가져오기
    let currentUser = AuthStore.shared.currentUser
    
    /// 각 페이지에 나타날 첫 번째 인덱스
    var startIndex: Int {
        // 선택된 페이지를 기반으로 시작 인덱스를 계산
        print("\((promise.selectedPage - 1) * 10)")
        return (promise.selectedPage - 1) * 10
    }
    
    /// 각 페이지에 나타날 마지막 인덱스
    var endIndex: Int {
        // 선택된 페이지가 과거 약속의 마지막 페이지와 같은지 확인
        if promise.selectedPage == promise.pastPromisePage {
            // 마지막 페이지에 대한 과거 약속 데이터의 수를 출력하고 반환
            print("\(promise.fetchPastPromiseData.count)")
            return promise.fetchPastPromiseData.count
        } else {
            // 보통 페이지의 끝 인덱스를 출력하고 반환
            print("\((promise.selectedPage - 1) * 10 + 10)")
            return (promise.selectedPage - 1) * 10 + 10
        }
    }
    
    var body: some View {
        VStack {
            if promise.isLoading == false {
                VStack {
                    // 과거 약속 배열이 비어 있는지 확인
                    if promise.fetchPastPromiseData.isEmpty {
                        Text("지난 약속 내역이 없습니다")
                            .foregroundStyle(.secondary)
                    } else {
                        ScrollView {
                            ForEach(promise.fetchPastPromiseData[startIndex ..< endIndex]) { promise in
                                NavigationLink {
                                    // 선택한 약속으로 ArriveResultView로 이동
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
                                            
                                            // 약속 날짜를 변환하여 표시
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
                                            }
                                        }
                                        .font(.callout)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.primary).opacity(0.5)
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
                                .disabled(page == promise.selectedPage)
                                .foregroundColor(page == promise.selectedPage ? .cider : .secondary)
                            }
                        }
                    }
                }
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
