//
//  PromiseDetailView.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/21.
//

import SwiftUI
import UIKit

enum SharingStatus: String {
    case preparing = "위치 공유 준비중"
    case sharing = "위치 공유중"
}

struct PromiseDetailView: View {
    // MARK: - Property Wrappers
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    @Environment(\.dismiss) private var dismiss
    @State private var currentDate: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var isShowingEditView: Bool = false
    @State private var isShowingShareSheet: Bool = false
    var color: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    
    // MARK: - Properties
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    // 약속시간 30분 전 활성화
    var destinagionStatus: SharingStatus {
        remainingTime < 60 * 30 ? .sharing : .preparing
    }
    var statusColor: Color {
        remainingTime < 60 * 30 ? .primary : .secondary
    }
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                sharingStatusView
                
                titleView
                
                destinationView
                
                dateView
                
                remainingTimeView
                
                FriendsLocationStatusView()
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
        .navigationDestination(isPresented: $isShowingEditView) {
            // TODO: 수정뷰
        }
        .sheet(
            isPresented: $isShowingShareSheet,
            onDismiss: { print("Dismiss") },
            content: { ActivityViewController(activityItems: ["https://zipadoo.onelink.me/QgIh/51ibebbu"]) }
        )
    }
    
    // MARK: - some Views
    private var zipadooToolbarView: some View {
        HStack {
            Button {
                isShowingShareSheet = true
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            
            Menu {
                Button {
                    isShowingEditView = true
                } label: {
                   Text("수정")
                }
                Button {
                    // TODO: 파베에서 해당 약속 delete
                    dismiss()
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
            .foregroundStyle(.white)
            .font(.caption).bold()
            .padding([.vertical, .horizontal], 12)
            .background(Color(color))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.bottom, 12)
    }
    
    private var titleView: some View {
        Text(promiseDetailStore.promise.promiseTitle)
            .font(.largeTitle)
            .bold()
            .padding(.vertical, 12)
    }
    
    private var dateView: some View {
        Text(("일시 : \(promiseDetailStore.calculateDate(date: promiseDetailStore.promise.promiseDate))"))
            .padding(.vertical, 3)
    }
    
    private var destinationView: some View {
        Text("장소 : \(promiseDetailStore.promise.destination)")
    }
    
    private var remainingTimeView: some View {
        Text(formatRemainingTime(time: remainingTime))
            .foregroundStyle(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(Color(color))
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.vertical, 12)
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
