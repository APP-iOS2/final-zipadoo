//
//  PromiseTestData.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

import Foundation

let promise = Promise(makingUserID: "1", promiseTitle: "만나자!", promiseDate: 1696553656.355991, destination: "서울역", participantIdArray: ["1", "2"], checkDoublePromise: false, locationIdArray: ["1", "2"])
let promise1 = Promise(makingUserID: "1", promiseTitle: "전역", promiseDate: 1696551656.355991, destination: "대전역", participantIdArray: ["1", "2"], checkDoublePromise: false, locationIdArray: ["1", "2"])