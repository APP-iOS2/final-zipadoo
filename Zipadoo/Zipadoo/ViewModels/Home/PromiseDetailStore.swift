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
                              participantsID: ["3", "4", "5"],
                              promiseDate: 1696285371.302136,
                              promiseTime: 0,
                              checkDoublePromise: false,
                              percentageIdArray: ["35", "34", "89"])
    }
}

struct Promise {
    /// 약속 ID 값
    let id: String
    /// 약속 생성 사용자 ID 값
    let makingUserID: String
    /// 장소
    var destination: String
    /// 약속 제목
    var promiseTitle: String
    /// 참여자 ID 값
    var participantsID: [String]
    /// 약속 날짜
    var promiseDate: Double
    /// 약속 시간
    var promiseTime: Double // promiseDate에 시간 값도 있을거라 요건 없어도 될 것 같아여
    /// 약속 중복 값 확인
    var checkDoublePromise: Bool
    /// 밑에 Percentage모델 id 배열
    var percentageIdArray : [String] //위에 participantsID대신에 이거는 어떠신가여
}
