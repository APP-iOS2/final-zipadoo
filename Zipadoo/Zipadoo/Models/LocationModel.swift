//
//  LocationModel.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/22.
//  Edited, by 이재승 2023/10/12.

import Foundation
import MapKit

struct Location: Identifiable, Codable {
    /// id
    var id = UUID().uuidString
    /// 사용자 id, 유저 이름, 이미지는 유저 id로 가져오기
    var participantId: String
    /// 출발 위도
    var departureLatitude: Double
    /// 출발 경도
    var departureLongitude: Double
    /// 출발 위치값
    var departureCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: departureLatitude, longitude: departureLongitude)
    }
    /// 현재 위도
    var currentLatitude: Double
    /// 현재 경도
    var currentLongitude: Double
    /// 현재 위치값
    var currentCoordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: currentLatitude, longitude: currentLongitude)
    }
    /// 도착했을 때 저장 -> '_분 일찍 도착'에 사용될 것 같음.
    var arriveTime: Double = 0
    /// 도착했을때 순위(지각한사람도 순위 저장되며 도착못한 사람은 0)
    var rank: Int = 0
}
