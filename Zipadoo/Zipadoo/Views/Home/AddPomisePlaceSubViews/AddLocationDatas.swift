//
//  LocationDatas.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import CoreLocation

// MARK: - 사용 안함
// 사용 안함
// struct AddLocation: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
// }

// MARK: - 직접 등록 맵뷰에 필요한 LocationManager 클래스
/// 직접 등록 맵뷰에 필요한 LocationManager 클래스
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
    }
}
// MARK: - 장소 등록에 필요한 구조체 데이터
/// 약속장소 등록을 위해 거쳐가는 단계의 구조체 값
struct PromiseLocation: Identifiable, Codable {
    var id: String = UUID().uuidString
    var destination: String // 주소
    var address: String // 주소
    var latitude: Double // 위도
    var longitude: Double // 경도
}

// MARK: - 직접 등록 맵뷰에 필요한 클래스 데이터
/// 직접 등록 맵뷰에 필요한 클래스 데이터
class AddLocationStore {
    func setLocation(destination: String, address: String, latitude: Double, longitude: Double) -> PromiseLocation {
        let location = PromiseLocation(destination: destination, address: address, latitude: latitude, longitude: longitude)
        return location
    }
}
