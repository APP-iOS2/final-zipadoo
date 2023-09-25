//
//  PayingView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/21.
//

import SwiftUI

struct PayingView: View {
    @State private var isShowingToss: Bool = false
    var body: some View {
        VStack {
            Text("감자 충전, 이제 \n 토스로 해보세요")
                .font(.title)
                .bold()
            Image(systemName: "bitcoinsign.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(30)
                .foregroundColor(.blue)
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                Button(action: {isShowingToss = true}, label: {
                    Text("토스 충전하러가기")
                })
            }
        }
        .navigationTitle("충전하기")
        .sheet(isPresented: $isShowingToss, content: {
            TossPayView(isShownFullScreenCover: $isShowingToss)
        })
    }
}

#Preview {
    NavigationStack {
        PayingView()
    }
}
