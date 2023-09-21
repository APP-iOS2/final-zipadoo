//
//  FriendsLocationMapViewModel.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/22.
//

import Foundation
import MapKit

class FriendsLocationMapViewModel: ObservableObject {
    
    // map의 위치 및 크기
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        span: MKCoordinateSpan())
    var minLatitude: Double = 0.0
    var maxLatitude: Double = 0.0
    var minLongitude: Double = 0.0
    var maxLongitude: Double = 0.0
    
    // 약속장소가 두 군데 이거나 경유가 필요할 경우를 대비해 배열로 추후엔 데이터 받아오기
    let destination: [Location] = [
        Location(coordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323), title: "약속장소")
    ]
    
    // 친구 데이터도 추후엔 받아오기
    let friendsLocation: [Location] = [
        Location(coordinate: CLLocationCoordinate2D(latitude: 37.574544, longitude: 127.186884), title: "정한두"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 37.609547, longitude: 127.097594), title: "임병구"),
        Location(coordinate: CLLocationCoordinate2D(latitude: 37.555798, longitude: 126.924019), title: "윤해수")
    ]
    
    func calculateRegion() {
        let destinationLatitude = destination[0].coordinate.latitude
        let destinationLongitude = destination[0].coordinate.longitude
                
        // 친구들의 좌표 중 위도가 가장 작은 값 불러오기
        if let minLatitudeLocation = friendsLocation.min(by: {
            $0.coordinate.latitude < $1.coordinate.latitude }) {
            minLatitude = minLatitudeLocation.coordinate.latitude
        }
        
        // 친구들의 좌표 중 위도가 가장 큰 값 불러오기
        if let maxLatitudeLocation = friendsLocation.max(by: {
            $0.coordinate.latitude < $1.coordinate.latitude }) {
            maxLatitude = maxLatitudeLocation.coordinate.latitude
        }

        // 친구들의 좌표 중 경도가 가장 작은 값 불러오기
        if let minLongitudeLocation = friendsLocation.min(by: {
            $0.coordinate.longitude < $1.coordinate.longitude }) {
            minLongitude = minLongitudeLocation.coordinate.longitude
        }

        // 친구들의 좌표 중 경도가 가장 큰 값 불러오기
        if let maxLongitudeLocation = friendsLocation.max(by: {
            $0.coordinate.longitude < $1.coordinate.longitude }) {
            maxLongitude = maxLongitudeLocation.coordinate.longitude
        }
                
        let latitudeDelta = abs(maxLatitude - minLatitude)
        let longitudeDelta = abs(maxLongitude - minLongitude)
        region.center.latitude = destinationLatitude
        region.center.longitude = destinationLongitude
        
        // 맵의 크기를 서로 가장 먼 친구들의 차이값을 불러왔으나 일부 부족하여 임의로 1.5값을 곱함.
        region.span.latitudeDelta = latitudeDelta * 1.5
        region.span.longitudeDelta = longitudeDelta * 1.5
    }
}
