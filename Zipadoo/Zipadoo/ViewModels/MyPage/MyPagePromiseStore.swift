//
//  MyPagePromiseStore.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/04.
//

import Foundation

final class MyPagePromiseStore: ObservableObject {
    @Published var promises: [Promise] = []
    
    @Published var testPromises: [Promise] = [
        Promise(id: "", makingUserID: "", promiseTitle: "모각코", promiseDate: convertDateToDouble("2023년 9월 29일"), destination: "서울어딘가", address: "test", latitude: 0.0, longitude: 0.0, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
        Promise(id: "", makingUserID: "", promiseTitle: "살기좋은도시 용인", promiseDate: convertDateToDouble("2023년 9월 25일"), destination: "용인", address: "test", latitude: 0.0, longitude: 0.0,  participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
        Promise(id: "", makingUserID: "", promiseTitle: "스터디", promiseDate: convertDateToDouble("2023년 9월 23일"), destination: "서울어딘가", address: "test", latitude: 0.0, longitude: 0.0,  participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
        Promise(id: "", makingUserID: "", promiseTitle: "병구님과 약속", promiseDate: convertDateToDouble("2023년 8월 25일"), destination: "서울어딘가", address: "test", latitude: 0.0, longitude: 0.0,  participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10)
    ]
}
