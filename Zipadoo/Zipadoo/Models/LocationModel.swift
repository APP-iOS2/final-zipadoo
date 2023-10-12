//
//  LocationModel.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/22.
//

import Foundation

struct Location: Codable {
    /// id
    var id: String
    /// 사용자 id
    let participantId: String
    /// 출발지점
    var departure: String?
    /// 현재 위치
    var currentLocation: String?
    /// 도착했을 때 저장 -> '_분 일찍 도착'에 사용될 것 같음.
    var arriveTime: Double?
}
