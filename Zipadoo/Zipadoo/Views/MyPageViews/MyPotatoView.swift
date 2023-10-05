//
//  MyPotatoView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPotatoView: View {
    @StateObject var myPagePromiseStore = MyPagePromiseStore()
    @State private var isShownFullScreenCover: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("1,000")
                    .font(.title2)
                    .bold()
                
                Spacer()
                
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
            
            List(myPagePromiseStore.testPromises) { promise in
                // 약속 리스트
                HStack {
                    VStack(alignment: .leading) {
                        Text(promise.promiseTitle)
                            .font(.title3)
                            .bold()
                            .padding(.bottom)
                        Text(convertDoubleToDate(promise.promiseDate))
                    }
                    Spacer()
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
