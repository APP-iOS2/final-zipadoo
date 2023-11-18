//
//  CustomDatePickerView.swift
//  Zipadoo
//
//  Created by 윤해수 on 11/14/23.
//

import SwiftUI

// Custom Date Picker...
struct CustomDatePicker: View {
    
    @StateObject var promiseViewModel: PromiseViewModel
    
    /// 날짜 선택 값
    @Binding var date: Date
    /// 시트 선택 불리언 값
    @Binding var showPicker: Bool
    
    /// 최소 설정 시간
    let minLimitTime = Calendar.current.date(byAdding: .minute, value: 30, to: Date()) ?? Date()
    
    var body: some View {
        ZStack {
            // today -> 분단위 표시되는 Date()로 변경
            DatePicker("현재시간으로 부터 30분 뒤부터 선택 가능", selection: $date, in: minLimitTime..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .labelsHidden()
                .onAppear {
                    date = minLimitTime
                }
            
            // 닫는 버튼
            Button {
                withAnimation {
                    showPicker.toggle()
                }
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.primary)
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        } // ZStack
        .opacity(showPicker ? 1 : 0)
    } // body
} // struct

//#Preview {
//    CustomDatePicker()
//}
