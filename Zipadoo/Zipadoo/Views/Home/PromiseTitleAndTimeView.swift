//
//  PromiseTitleAndTimeView.swift
//  Zipadoo
//
//  Created by 장여훈 on 11/14/23.
//

import SwiftUI

/// PromiseDetailMapSubView에서 사용
struct PromiseTitleAndTimeView: View {
    var promise: Promise
    
    // 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 남은 시간을 표시할 상태 변수
    @State private var RemainingTime: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // 약속 제목
            Text("\(promise.promiseTitle)")
                .font(.title)
                .padding(.top)
                .padding(.bottom)
                .bold()
            
            // 약속 장소 정보
            HStack {
                Image(systemName: "pin")
                Text("\(promise.destination)")
            }
            
            // 약속 일시 정보
            let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
            HStack {
                Image(systemName: "clock")
                Text("\(formatDate(date: datePromise))")
            }
            
            // 남은 시간 표시
            Text("남은시간 : \(RemainingTime)")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
        }
        .padding(.leading)
        .padding(.trailing)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.primary)
                .opacity(0.05)
                .shadow(color: .primary, radius: 10, x: 5, y: 5)
        )
        .task {
            // 초기에 남은 시간 설정
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .onReceive(timer) { _ in
            // 1초마다 남은 시간 갱신
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
    }
}
