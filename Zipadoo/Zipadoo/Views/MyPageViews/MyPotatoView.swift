//
//  MyPotatoView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct MyPotatoView: View {
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
                Text("총 3,000개")
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
                        Text("지각")
                            .font(.title2)
                            .bold()
                        Text("-500")
                            .foregroundColor(.red)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("스터디 모임")
                            .font(.title2)
                            .bold()
                        Text("2023.09.03")
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Text("정산")
                            .font(.title2)
                            .bold()
                        Text("+500")
                            .foregroundColor(.green)
                    }
                }
                HStack {
                    VStack(alignment: .leading) {
                        Text("지파두")
                            .font(.title2)
                            .bold()
                        Text("2023.09.01")
                    }
                    Spacer()
                    VStack(alignment: .listRowSeparatorTrailing) {
                        Text("충전")
                            .font(.title2)
                            .bold()
                        Text("+1,000")
                            .foregroundColor(.green)

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
