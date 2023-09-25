//
//  MyPotatoView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPotatoView: View {
    @State private var isShowingToss: Bool = false
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("10,000")
                Spacer()
                Button(action: {isShowingToss = true}, label: {
                    Text("충전하기")
                })
            }
            .font(.title2)
            .bold()
            .padding()
            
            HStack {
                Text("총 정산 금액")
                    .bold()
                Spacer()
                Text("총 300,000원")
                    .foregroundColor(.red)
            }
            .padding(.leading)
            .padding(.trailing)
            
            Divider()
            
            List {
                HStack {
                    VStack(alignment: .leading) {
                        Text("임병구님과의 약속")
                            .font(.title2)
                            .bold()
                        Text("2023.09.06")
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Text("지각확정")
                            .font(.title2)
                            .bold()
                        Text("정산 5,000원")
                    }
                    .foregroundColor(.red)
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("나의 감자")
        .sheet(isPresented: $isShowingToss, content: {
            TossPayView(isShownFullScreenCover: $isShowingToss)
        })
    }
}

#Preview {
    NavigationStack {
        MyPotatoView()
    }
}
