//
//  PromiseModel.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/22.
//

import Foundation

struct Promise: Hashable {
    /// 약속 ID 값
    let id: String = UUID().uuidString
    /// 약속 생성 사용자 ID 값
    let makingUserID: String
    /// 약속 제목
    var promiseTitle: String
    /// 약속 날짜
    var promiseDate: Double
    /// 장소
    var destination: String
    /// 참여자 ID 값
    var participantIdArray: [String]
    /// 약속 중복 값 확인
    var checkDoublePromise: Bool
    /// 밑에 Percentage모델 id 배열
    var locationIdArray: [String]
    
    init(makingUserID: String, promiseTitle: String, promiseDate: Double, destination: String, participantIdArray: [String], checkDoublePromise: Bool, locationIdArray: [String]) {
        self.makingUserID = makingUserID
        self.promiseTitle = promiseTitle
        self.promiseDate = promiseDate
        self.destination = destination
        self.participantIdArray = participantIdArray
        self.checkDoublePromise = checkDoublePromise
        self.locationIdArray = locationIdArray
    }
    
    init() {
        self.makingUserID = ""
        self.promiseTitle = ""
        self.promiseDate = 10.0
        self.destination = ""
        self.participantIdArray = ["1", "2"]
        self.checkDoublePromise = false
        self.locationIdArray = ["1", "2"]
    }
}
