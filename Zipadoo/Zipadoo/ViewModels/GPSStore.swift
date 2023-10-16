//
//  GPSStore.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/10.
//

import Foundation
import CoreLocation

// 유저 Location 데이터를 가지고 오기 위한 Store, *LocationStore와 이름이 중복될 수 있어, 일단 GPSStore로 지음.
final class GPSStore: NSObject, ObservableObject, CLLocationManagerDelegate {
    // 위치 공유 동의 확인 상태 프로퍼티
    @Published var authorizationStatus: CLAuthorizationStatus
    // 현재 위치를 공유해주는 프로퍼티
    @Published var lastSeenLocation: CLLocation?
    // 현재 도시, 지역등을 알려주는 프로퍼티
    @Published var currentPlacemark: CLPlacemark?
    
    private let locationManager: CLLocationManager
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        print("GPSStore 초기화 완료 \(String(describing: lastSeenLocation?.coordinate))")
    }
    // 위치 공유 동의 확인 메서드
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastSeenLocation = locations.first
        fetchCountryAndCity(for: locations.first)
    }

    func fetchCountryAndCity(for location: CLLocation?) {
        guard let location = location else { return print("location값이 nil입니다.") }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let placemark = placemarks?.first else {
                return print(error as Any)
            }
            self.currentPlacemark = placemark
        }
    }
}
