//
//  PromiseModel.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/22.
//

import Foundation
import MapKit

struct Promise: Hashable, Identifiable, Codable {
    /// 약속 ID 값
    var id: String
    /// 약속 생성 사용자 ID 값
    var makingUserID: String
    /// 약속 제목
    var promiseTitle: String
    /// 약속 날짜
    var promiseDate: Double
    /// 장소
    var destination: String
    /// 주소
    var address: String
    /// 위도
    var latitude: Double
    /// 경도
    var longitude: Double
    /// 위치값
    var coordinate: CLLocationCoordinate2D { 
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    /// 참여자 ID 값
    var participantIdArray: [String]
    /// 약속 중복 값 확인
    var checkDoublePromise: Bool
    /// 밑에 Percentage모델 id 배열
    var locationIdArray: [String]
    /// 지각비
    var penalty: Int
    
    init(id: String, makingUserID: String, promiseTitle: String, promiseDate: Double, destination: String, address: String, latitude: Double, longitude: Double, participantIdArray: [String], checkDoublePromise: Bool, locationIdArray: [String], penalty: Int) {
        self.id = id
        self.makingUserID = makingUserID
        self.promiseTitle = promiseTitle
        self.promiseDate = promiseDate
        self.destination = destination
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.participantIdArray = participantIdArray
        self.checkDoublePromise = checkDoublePromise
        self.locationIdArray = locationIdArray
        self.penalty = penalty
    }
    
    init() {
        self.id = ""
        self.makingUserID = ""
        self.promiseTitle = ""
        self.promiseDate = 10.0
        self.destination = ""
        self.address = ""
        self.latitude = 0.0
        self.longitude = 0.0
        self.participantIdArray = ["1", "2"]
        self.checkDoublePromise = false
        self.locationIdArray = ["1", "2"]
        self.penalty = 0
    }
}
