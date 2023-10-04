//
//  PastPromiseView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

import SwiftUI

struct PastPromiseView: View {
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
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 5)
                        Text(convertDoubleToDate(promise.promiseDate))
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Text("지각")
                            .font(.headline)
                            .bold()
                            .padding(.bottom, 5)
                        Text("-500")
                            .font(.subheadline)
                            .bold()
                            .foregroundColor(.red)
                    }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("지난 약속")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PastPromiseView()
    }
}
