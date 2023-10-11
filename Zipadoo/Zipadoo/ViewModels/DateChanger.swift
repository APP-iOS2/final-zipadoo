//
//  DateChanger.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

// 날짜값 변경시 필요한 함수들
import Foundation

// 날짜 Double값을 변환해주는 함수
func convertDateToDouble(_ date: String) -> Double {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
    let date = dateFormatter.date(from: date)
    let doubleValue = date?.timeIntervalSinceReferenceDate ?? 0.0
    
    return doubleValue
}

// 날짜 String값을 변환해주는 함수
func convertDoubleToDate(_ double: Double) -> String {
    let date = Date(timeIntervalSinceReferenceDate: double)
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일"
    return dateFormatter.string(from: date)
}
