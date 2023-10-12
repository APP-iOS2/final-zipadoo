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
    case done = "약속 종료하기"
}

struct PromiseDetailView: View {
    // MARK: - Property Wrappers
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    @ObservedObject var promiseViewModel: PromiseViewModel = PromiseViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var currentDate: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var isShowingEditView: Bool = false
    @State private var isShowingShareSheet: Bool = false
    @StateObject var deletePromise: PromiseViewModel = PromiseViewModel()
    @State private var isShowingDeleteAlert: Bool = false
    let promise: Promise
    let activeColor: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    let disabledColor: UIColor = #colorLiteral(red: 0.7725487947, green: 0.772549212, blue: 0.7811570764, alpha: 1)
    
    // MARK: - Properties
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    // 약속시간 30분 전 활성화
    var destinagionStatus: SharingStatus {
        remainingTime > 60 * 30 ? .preparing : remainingTime > 0 ? .sharing : .done
    }
    var statusColor: Color {
        destinagionStatus == .preparing ? Color(disabledColor) : Color(activeColor)
    }
    var isDisableLocationButton: Bool {
        remainingTime > 60 * 30
    }
    var isDisableEndButton: Bool {
        destinagionStatus != .done
    }
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    sharingStatusView
                    
                    titleView
                    
                    destinationView
                    
                    dateView
                    
                    remainingTimeView
                    
                    FriendsLocationStatusView()
                }
            }
            .padding(.horizontal, 12)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    zipadooToolbarView
                }
            }
        }
        .alert(isPresented: $isShowingDeleteAlert) {
            Alert(
                title: Text("약속 내역을 삭제합니다."),
                message: Text("해당 작업은 복구되지 않습니다."),
                primaryButton: .destructive(Text("삭제하기"), action: {
                    deletePromise.deletePromiseData(promiseId: promise.id, locationIdArray: promise.locationIdArray)
                    dismiss()
                }),
                secondaryButton: .default(Text("돌아가기"), action: {
                })
            )
        }
        
        .onAppear {
            currentDate = Date().timeIntervalSince1970
            formatRemainingTime()
        }
        .onReceive(timer, perform: { _ in
            currentDate = Date().timeIntervalSince1970
            formatRemainingTime()
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
                    isShowingDeleteAlert.toggle()
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
        Button {
            // TODO: 약속 종료 Bool값 toggle
        } label: {
            Text(destinagionStatus.rawValue)
                .foregroundStyle(.white)
                .font(.caption).bold()
        }
        .padding([.vertical, .horizontal], 12)
        .background(statusColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.bottom, 12)
        .disabled(isDisableEndButton)
    }
    
    private var titleView: some View {
        Text(promise.promiseTitle)
            .font(.largeTitle)
            .bold()
            .padding(.vertical, 12)
    }
    
    private var dateView: some View {
        Text(("일시 : \(calculateDate(date: promise.promiseDate))"))
            .padding(.vertical, 3)
    }
    
    private var destinationView: some View {
        Text("장소 : \(promise.destination)")
    }
    
    private var remainingTimeView: some View {
        Button {
            // TODO: 위치 현황뷰(지도ver) 이동
        } label: {
            Text(formatRemainingTime())
                .foregroundStyle(.white)
                .bold()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(statusColor)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .padding(.vertical, 12)
        .disabled(isDisableLocationButton)
    }
    
    // MARK: Custom Methods
    private func calculateDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 | a hh:mm"
        return dateFormatter.string(from: date)
    }
    
    private func formatRemainingTime() -> String {
        let promiseDate = promise.promiseDate
        remainingTime = promiseDate - currentDate
        switch remainingTime {
//        case 1..<60:
//            return "약속 시간이 거의 다 됐어요!"
        case 60..<1800:
            let minute = remainingTime / 60
            return "약속 \(Int(minute)+1)분 전"
        case 1800..<3600:
            return "친구의 위치 현황을 확인해보세요!"
        case 3600..<86400:
            let hours = remainingTime / (60 * 60)
            return "약속 \(Int(hours)+1)시간 전"
        case 86400...:
            let days = calculateRemainingDate(current: currentDate, promise: promiseDate)
            return "약속 \(days)일 전"
        default:
            return "약속 시간이 됐어요!"
        }
    }
    
    private func calculateRemainingDate(current: Double, promise: Double) -> Int {
        let calendar = Calendar.current
        
        let nowDate = Date(timeIntervalSince1970: current)
        let promiseDate = Date(timeIntervalSince1970: promise)
        
        let startOfToday = calendar.startOfDay(for: nowDate)
        let startOfPromiseDay = calendar.startOfDay(for: promiseDate)
        
        let components = calendar.dateComponents([.day], from: startOfToday, to: startOfPromiseDay)
        
        if let days = components.day {
            return days
        }
        
        return -1
    }
}

#Preview {
    PromiseDetailView(promise:
                        Promise(
                            id: "",
                            makingUserID: "3",
                            promiseTitle: "지파두 모각코^ㅡ^",
                            promiseDate: 1697094371.302136,
                            destination: "서울특별시 종로구 종로3길 17",
                            address: "",
                            latitude: 0.0,
                            longitude: 0.0,
                            participantIdArray: ["3", "4", "5"],
                            checkDoublePromise: false,
                            locationIdArray: ["35", "34", "89"]))
}
