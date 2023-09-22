//
//  PromiseDetailView.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/21.
//

import SwiftUI

enum SharingStatus: String {
    case preparing = "위치 공유 준비중"
    case sharing = "위치 공유중"
}

struct PromiseDetailView: View {
    // MARK: - Property WrapperS
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    @State private var currentDate: Double = 0.0
    @State private var remainingTime: Double = 0.0
    
    // MARK: - Properties
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    var destinagionStatus: SharingStatus {
        remainingTime < 3600 ? .sharing : .preparing
    }
    var statusColor: Color {
        remainingTime < 3600 ? .primary : .secondary
    }
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                sharingStatusView
                
                titleView
                
                dateView
                
                destinationView
                
                remainingTimeView
                
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
    
    // MARK: - some Views
    private var zipadooToolbarView: some View {
        HStack {
            Button {
                print(Date().timeIntervalSince1970)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            
            Menu {
                Button {
                    print("수정")
                } label: {
                   Text("수정")
                }
                Button {
                    print("삭제")
                } label: {
                   Text("삭제")
                }
            } label: {
                Label("More", systemImage: "ellipsis")
            }
        }
        .foregroundColor(.secondary)
    }
    
    private var sharingStatusView: some View {
        Text(destinagionStatus.rawValue)
            .foregroundStyle(statusColor)
            .font(.caption).bold()
            .padding([.vertical, .horizontal], 12)
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 5)
    }
    
    private var titleView: some View {
        Text(promiseDetailStore.promise.promiseTitle)
            .font(.largeTitle)
            .bold()
    }
    
    private var dateView: some View {
        Text(promiseDetailStore.calculateDate(date: promiseDetailStore.promise.promiseDate))
            .padding(.bottom, 1)
    }
    
    private var destinationView: some View {
        Text(promiseDetailStore.promise.destination)
    }
    
    private var remainingTimeView: some View {
        Text(formatRemainingTime(time: remainingTime))
            .foregroundStyle(statusColor)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.yellow)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    // MARK: Custom Methods
    private func calculateRemainingTime() {
        let promiseDate = promiseDetailStore.promise.promiseDate
        remainingTime = promiseDate - currentDate
    }
    
    private func formatRemainingTime(time: Double) -> String {
        switch time {
        case 1...60:
            return "약속 시간이 거의 다 됐어요!"
        case 61...3600:
            let minute = time / 60
            return "약속 \(Int(minute))분 전"
        case 3601...86400:
            let hours = time / (60 * 60)
            return "약속 \(Int(hours))시간 전"
        case 86401...:
            let days = time / (24 * 60 * 60)
            return "약속 \(Int(days))일 전"
        default:
            return "약속 시간이 됐어요!"
        }
    }
}

#Preview {
    PromiseDetailView()
}
