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
    @EnvironmentObject var promiseViewModel: PromiseViewModel
    @StateObject var loginUser: UserStore = UserStore()
    @EnvironmentObject var widgetStore: WidgetStore
    
    @Environment(\.dismiss) private var dismiss
    @State private var currentDate: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var isShowingEditSheet: Bool = false
    @State private var isShowingShareSheet: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    @State private var navigateBackToHome: Bool = false
    @State var promise: Promise
    let activeColor: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    let disabledColor: UIColor = #colorLiteral(red: 0.7725487947, green: 0.772549212, blue: 0.7811570764, alpha: 1)
    
    // MARK: - Properties
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 약속시간 30분 전 활성화
    var destinagionStatus: SharingStatus {
        remainingTime > 60 * 30 ? .preparing : .sharing
    }
    var statusColor: Color {
        destinagionStatus == .preparing ? Color(disabledColor) : Color(activeColor)
    }
    
    // MARK: - body
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading) {
                    titleView
                    
                    destinationView
                    
                    dateView
                    
                    remainingTimeView
                    
                    memberStatusView
                }
            }
            .padding(.horizontal, 15)
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
                    Task {
                        do {
                            try await promiseViewModel.deletePromiseData(promiseId: promise.id, locationIdArray: promise.locationIdArray)
                            
                            dismiss()
                        } catch {
                            print("실패")
                        }
                    }
                }),
                secondaryButton: .default(Text("돌아가기"), action: {
                })
            )
        }
        .onAppear {
            currentDate = Date().timeIntervalSince1970
            formatRemainingTime()
            widgetStore.widgetPromiseID = nil
            widgetStore.widgetPromise = nil
            widgetStore.isShowingDetailForWidget = false
        }
        .onReceive(timer, perform: { _ in
            currentDate = Date().timeIntervalSince1970
            formatRemainingTime()
        })
        .onAppear {
            if navigateBackToHome {
                dismiss()
            }
            Task {
                try await promiseViewModel.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
            }
        }
        .refreshable {
            Task {
                try await promiseViewModel.fetchData(userId: AuthStore.shared.currentUser?.id ?? "")
            }
        }
        //        .navigationDestination(isPresented: $isShowingEditSheet) {
        //            PromiseEditView(promise: .constant(promise))
        //        }
//        .onAppear {
//            Task {
//                try await promiseViewModel.fetchData()
//            }
//        }
//        .refreshable {
//            Task {
//                try await promiseViewModel.fetchData()
//            }
//        }
//        .navigationDestination(isPresented: $isShowingEditSheet) {
//            PromiseEditView(promise: .constant(promise))
//        }
        .sheet(isPresented: $isShowingEditSheet,
               content: { PromiseEditView(promise: .constant(promise), navigationBackToHome: $navigateBackToHome)
        })
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
                if loginUser.currentUser?.id == promise.makingUserID {
//                    Button {
//                        isShowingEditSheet.toggle()
//                    } 
                    NavigationLink {
                        PromiseEditView(promise: .constant(promise), navigationBackToHome: $navigateBackToHome)
                    } label: {
                        Text("수정")
                    }
                } else if promise.participantIdArray.contains(loginUser.currentUser?.id ?? "") {
                    Button {
                        if let userId = loginUser.currentUser?.id {
                            // 현재 로그인한 사용자 아이디 가져오기
                            
                            if let index = promise.participantIdArray.firstIndex(of: userId) {
                                // 배열에서 ID 위치 확인
                                // 해당 ID 배열에서 제거
                                let locationIndex = index + 1
                                promise.participantIdArray.remove(at: index)
                                promise.locationIdArray.remove(at: locationIndex) // 약속 나가기 오류발견!
                            }
                            
                            Task {
                                try await promiseViewModel.exitPromise(promise, locationId: userId)
                            }
                        }
                    } label: {
                        Text("약속나가기")
                    }
                }
                
                if loginUser.currentUser?.id == promise.makingUserID {
                    Button {
                        isShowingDeleteAlert.toggle()
                    } label: {
                        Text("삭제")
                    }
                }
            } label: {
                Label("More", systemImage: "ellipsis")
            }
        }
        .foregroundColor(.secondary)
    }
    
//    private var titleView: some View {
//        Text(promise.promiseTitle)
//            .font(.title2).bold()
//            .padding(.bottom, 1)
//    }
//    
//    private var dateView: some View {
//        Text(("일시 : \(calculateDate(date: promise.promiseDate))"))
//            .padding(.vertical, 3)
//    }
//    
//    private var destinationView: some View {
//        Text("장소 : \(promise.destination)")
//    }
//    
//    private var remainingTimeView: some View {
//        Text(formatRemainingTime())
//            .foregroundStyle(.white)
//            .font(.title).bold()
//            .frame(maxWidth: .infinity)
//            .padding(.vertical, 15)
//            .background(statusColor)
//            .clipShape(RoundedRectangle(cornerRadius: 28))
//            .padding(.vertical, 12)
//            .opacity(0.8)
//    }
    
    private var memberStatusView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("친구 위치 현황")
                    .font(.title3).bold()
                
                Spacer()
                
                if destinagionStatus == .sharing {
                    Button {
                        // TODO: 지도 상세뷰로 navigation
                    } label: {
                        HStack {
                            Text("지도로 보기")
                            Image(systemName: "chevron.right")
                        }
                    }
                }
            }
            
            if destinagionStatus != .sharing {
                HStack {
                    Image(systemName: "info.circle")
                    Text("약속시간 30분 전부터 위치가 공유됩니다.")
                }
                .foregroundColor(.secondary)
                .font(.caption)
            }
            
//            FriendsLocationStatusView(promise: promise)
        }
    }
    
    // MARK: Custom Methods
    //    private func calculateRemainingTime() {
    //        let promiseDate = postPromise.promiseDate
    //        remainingTime = promiseDate - currentDate
    //    }
    
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
        case 1..<60:
            let second = Int(remainingTime) % 60
            return String(format: "약속까지 %02d초 전", second)
        case 60..<1800:
            let minute = Int(remainingTime) / 60
            let second = Int(remainingTime) % 60
            return String(format: "약속까지 %02d분 %02d초 전", minute, second)
        case 1800..<3600:
            let minute = Int(remainingTime) / 60
            return "약속까지 \(minute)분 전"
        case 3600..<86400:
            let hours = remainingTime / (60 * 60)
            let minute = Int(remainingTime) % (60 * 60) / 60
            var message = "약속까지 \(Int(hours))시간 "
            message += minute == 0 ? "전" : " \(minute)분 전"
            return message
        case 86400...:
            let days = calculateRemainingDate(current: currentDate, promise: promiseDate)
            return "약속까지 \(days)일 전"
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
// ArriveResult뷰에서 재사용 위해 extension으로 분리
extension PromiseDetailView {
    
    var titleView: some View {
        Text(promise.promiseTitle)
            .font(.title2).bold()
            .padding(.bottom, 1)
    }
    
    var dateView: some View {
        Text(("일시 : \(calculateDate(date: promise.promiseDate))"))
            .padding(.vertical, 3)
    }
    
    var destinationView: some View {
        Text("장소 : \(promise.destination)")
    }
    
    var remainingTimeView: some View {
        Text(formatRemainingTime())
            .foregroundStyle(.white)
            .font(.title).bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(statusColor)
            .clipShape(RoundedRectangle(cornerRadius: 28))
            .padding(.vertical, 12)
            .opacity(0.8)
    }
}

#Preview {
    PromiseDetailView(promise:
                        Promise(
                            id: "",
                            makingUserID: "3",
                            promiseTitle: "지각파는 두더지 모각코",
                            promiseDate: 1697101051.302136,
                            destination: "서울특별시 종로구 종로3길 17",
                            address: "",
                            latitude: 0.0,
                            longitude: 0.0,
                            participantIdArray: ["3", "4", "5"],
                            checkDoublePromise: false,
                            locationIdArray: ["35", "34", "89"],
                            penalty: 0))
}
