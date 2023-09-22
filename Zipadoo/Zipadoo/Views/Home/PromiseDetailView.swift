//
//  PromiseDetailView.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/21.
//

import SwiftUI

struct PromiseDetailView: View {
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    @State private var isDesabledDestinationStatus: Bool = true
    @State private var currentDate = Date().timeIntervalSince1970
    @State private var remainingTime: Double = 0.0
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text(remainingTime < 3600 ? "위치 공유중" : "위치 공유 준비중")
                    .bold()
                    .padding([.vertical, .horizontal], 12)
                    .background(.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text(promiseDetailStore.promise.promiseTitle)
                    .font(.largeTitle)
                    .bold()
                
                Text(promiseDetailStore.calculateDate(date: promiseDetailStore.promise.promiseDate))
                
                Text(promiseDetailStore.promise.destination)
                
                Button {
                    print(remainingTime)
                } label: {
                    Text(remainingTimeDateFormat(date: remainingTime))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.yellow)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(isDesabledDestinationStatus)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    zipadooToolbarView
                }
            }
        }
        .onAppear {
            currentDate = Date().timeIntervalSince1970
            calculateRemainingTime()
        }
        .onReceive(timer, perform: { _ in
            currentDate = Date().timeIntervalSince1970
            calculateRemainingTime()
        })
    }
    
    private var zipadooToolbarView: some View {
        HStack {
            Button {
                print(Date().timeIntervalSince1970)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .foregroundColor(.secondary)
    }
    
    private func calculateRemainingTime() {
        let promiseDate = promiseDetailStore.promise.promiseDate
        remainingTime = promiseDate - currentDate
        print(remainingTime)
    }
    
    private func remainingTimeDateFormat(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        
        switch remainingTime {
        case 1...60: return "약속 시간이 거의 다 됐어요!"
        case 61...3600: dateFormatter.dateFormat = "약속시간까지 mm분 전"
        case 3601...86400: dateFormatter.dateFormat = "약속시간까지 HH시간 전"
        case 86401...: dateFormatter.dateFormat = "약속시간까지 dd일 전"
        default: return "약속 시간이 되었어요!"
        }
        
        return dateFormatter.string(from: date)
    }
}

#Preview {
    PromiseDetailView()
}
