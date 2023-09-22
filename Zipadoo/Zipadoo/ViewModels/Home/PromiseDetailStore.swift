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
        self.promise = Promise(id: "1",
                              makingUserID: "3",
                              destination: "서울특별시 종로구 종로3길 17",
                              promiseTitle: "지파두 모각코^ㅡ^",
                              participantIdArray: ["3", "4", "5"],
                              promiseDate: 1697094371.302136,
                              checkDoublePromise: false,
                              percentageIdArray: ["35", "34", "89"])
    }
    
    func calculateDate(date: Double) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 MM월 dd일 | a hh:mm"
        return dateFormatter.string(from: date)
    }
}
