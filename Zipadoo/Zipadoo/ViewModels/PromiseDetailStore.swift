//
//  PromiseDetailStore.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/21.
//

import Foundation

class PromiseDetailStore: ObservableObject {
    @Published var promise: Promise
    
    init() {
        self.promise = Promise(
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
            locationIdArray: ["35", "34", "89"],
            penalty: 500)
    }
    
    func calculateDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 | a hh:mm"
        return dateFormatter.string(from: date)
    }
}
