//
//  MyPotatoView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

// MARK: - 내 감자 결제 이력
/// MyPotatoView (더미데이터)
struct MyPotatoView: View {
    /// 더미데이터
    @StateObject var myPagePromiseStore = MyPagePromiseStore()
    /// 감자 충전 시트뷰 Bool값
    @State private var isShownFullScreenCover: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                // MARK: - 현재 보유 감자
                // 더미데이터
                Image(systemName: "bitcoinsign.circle.fill")
                Text("1,000")
                    .font(.title2)
                    .bold()
                
                Spacer()
                // MARK: - 감자 충전뷰 연결
                Button(action: {isShownFullScreenCover.toggle()}, label: {
                    Text("충전하기")
                        .font(.title2)
                        .bold()
                })
                .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                    TossPayView(isShownFullScreenCover: $isShownFullScreenCover)
                })
                
            }
            .padding()
            // MARK: - 지각으로 낸 총 감자 수
            // 더미데이터
            HStack {
                Text("지각으로 낸 감자수")
                    .bold()
                Spacer()
                Text("총 2,000개")
                    .bold()
                    .foregroundStyle(.red)
            }
            .padding(.leading)
            .padding(.trailing)
            
            Divider()
            // MARK: - 감자 사용 세부이력(약속 & 지출한 감자)
            // 더미데이터, 지각 이력 제대로 나오지 않은 부분 수정
            List(myPagePromiseStore.testPromises, id: \.self) { promise in
                // 약속 리스트
                HStack {
                    VStack(alignment: .leading) {
                        // 약속 제목
                        Text(promise.promiseTitle)
                            .font(.title3)
                            .bold()
                            .padding(.bottom)
                        // 약속 날짜
                        Text(convertDoubleToDate(promise.promiseDate))
                    }
                    Spacer()
                    // 지각 및 지출한 감자
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Text("지각")
                            .font(.title3)
                            .bold()
                            .padding(.bottom)
                        Text("-500")
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("나의 감자")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        MyPotatoView()
    }
}
