//
//  LocationDatas.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import CoreLocation

struct Location: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

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

struct PromiseLocation: Identifiable, Codable {
    var id: UUID = UUID()
    let latitude: Double // 위도
    let longitude: Double // 경도
    let address: String // 주소
}

class LocationStore {
    func setLocation(latitude: Double, longitude: Double, address: String) -> PromiseLocation {
        let location = PromiseLocation(latitude: latitude, longitude: longitude, address: address)
        return location
    }
}
