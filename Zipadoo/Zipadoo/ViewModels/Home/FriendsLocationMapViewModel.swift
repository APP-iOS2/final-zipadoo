//
//  FriendsLocationMapViewModelExpectedTravelTime.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/04.
//

import SwiftUI
import MapKit

struct TravelTime {
    let distanceText: String
    let imageName: String
    let isMe: Bool
    let lineColor: UIColor // 새로운 변수 lineColor 추가
//    let userID: String
//    let userName: String
//    let userNickName: String
//    let userProfileImageString: String
//    let promiseID: String
//    let promiseMakingUserID: String
//    let promiseTitle: String
//    let promiseDate: String
//    let promiseDestination: String
//    let locationID: String
//    let coordinate: Double
}

// 1. Location 변경 쓸건지?, 새로운 구조체 쓸건지?,

class FriendsLocationMapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
    @Published var travelInfoDictionary: [String: TravelTime] = [:]

    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        span: MKCoordinateSpan()
    )

    private let mapView = MKMapView()
    
    // TravelTime에 사용할 색상 배열
    private let travelTimeColors: [UIColor] = [
        .red, .orange, .yellow, .green, .blue, .cyan, .purple, .brown, .black
    ]

    let destinationLocation: LocationAndInfo = LocationAndInfo(
        coordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
        title: "약속장소",
        imgString: "flag",
        isMe: false
    )
    var friendsLocation: [LocationAndInfo] = [
        LocationAndInfo(
            coordinate: CLLocationCoordinate2D(latitude: GPSStore().lastSeenLocation?.coordinate.latitude ?? 37.547551, longitude: GPSStore().lastSeenLocation?.coordinate.longitude ?? 127.080315),
            title: "정한두",
            imgString: "dragon",
            isMe: true
        ),
        LocationAndInfo(
            coordinate: CLLocationCoordinate2D(latitude: 37.547551, longitude: 127.080315),
            title: "임병구",
            imgString: "bear",
            isMe: false
        ),
        LocationAndInfo(
            coordinate: CLLocationCoordinate2D(latitude: 37.536981, longitude: 126.999426),
            title: "윤해수",
            imgString: "rabbit",
            isMe: false
        ),
        LocationAndInfo(
            coordinate: CLLocationCoordinate2D(latitude: 37.492266, longitude: 127.030677),
            title: "선아라",
            imgString: "owl",
            isMe: false
        )
    ]

    override init() {
        super.init()
        mapView.delegate = self
    }

    func makeMapView() -> MKMapView {
        return mapView
    }

    func removeAnnotationsAndOverlays() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)
    }

    func addDestinationPin() {
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.coordinate = destinationLocation.coordinate
        destinationAnnotation.title = destinationLocation.title
        mapView.addAnnotation(destinationAnnotation)
    }

    func addFriendPinsAndCalculateTravelTimes() {
        let myLocation = friendsLocation.first(where: { $0.isMe })

        for friendLocation in friendsLocation where friendLocation.isMe == false {
            let requestAnnotation = MKPointAnnotation()
            requestAnnotation.coordinate = friendLocation.coordinate
            requestAnnotation.title = friendLocation.title
            mapView.addAnnotation(requestAnnotation)

            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
            let friendPlacemark = MKPlacemark(coordinate: friendLocation.coordinate)

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: friendPlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .automobile

            let directions = MKDirections(request: directionRequest)
            directions.calculate { [weak self] response, error in
                guard let self = self, let response = response else { return }

                let friendName = friendLocation.title
                // 거리
//                let remainingDistance = response.routes[0].distance
                let remainingDistance = calculateDistanceInMeters(x1: friendLocation.coordinate.latitude, y1: friendLocation.coordinate.longitude, x2: destinationLocation.coordinate.latitude, y2: destinationLocation.coordinate.longitude)
                print("remainingDistance: \(remainingDistance)")
                let formattedDistance = self.formatDistance(remainingDistance)
                var lineColor: UIColor = .clear

                if let travelTime = self.travelInfoDictionary[friendName] {
                    lineColor = travelTime.lineColor
                } else {
                    lineColor = self.travelTimeColors[self.travelInfoDictionary.count % self.travelTimeColors.count]
                }

                // travelTimesText에 데이터를 저장합니다.
                let travelTime = TravelTime(distanceText: formattedDistance, imageName: friendLocation.imgString, isMe: false, lineColor: lineColor)
                self.travelInfoDictionary[friendName] = travelTime

                // mapView를 업데이트하고 뷰를 다시 그릴 수 있도록 알립니다.
                self.mapView.addOverlay(response.routes[0].polyline, level: .aboveRoads)
                self.objectWillChange.send()
            }
        }

        if let myLocation = myLocation {
            let requestAnnotation = MKPointAnnotation()
            requestAnnotation.coordinate = myLocation.coordinate
            requestAnnotation.title = myLocation.title
            mapView.addAnnotation(requestAnnotation)

            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
            let friendPlacemark = MKPlacemark(coordinate: myLocation.coordinate)

            let directionRequest = MKDirections.Request()
            directionRequest.source = MKMapItem(placemark: friendPlacemark)
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .automobile

            let directions = MKDirections(request: directionRequest)
            directions.calculate { [weak self] response, error in
                guard let self = self, let response = response else { return }

                let friendName = myLocation.title
                let remainingDistance = calculateDistanceInMeters(x1: myLocation.coordinate.latitude, y1: myLocation.coordinate.longitude, x2: destinationLocation.coordinate.latitude, y2: destinationLocation.coordinate.longitude)
                let formattedDistance = self.formatDistance(remainingDistance)
                var lineColor: UIColor = .clear

                if let travelTime = self.travelInfoDictionary[friendName] {
                    lineColor = travelTime.lineColor
                } else {
                    lineColor = self.travelTimeColors[self.travelInfoDictionary.count % self.travelTimeColors.count]
                }

                // travelTimesText에 데이터를 저장합니다.
                let travelTime = TravelTime(distanceText: formattedDistance, imageName: myLocation.imgString, isMe: true, lineColor: lineColor)
                self.travelInfoDictionary[friendName] = travelTime

                // mapView를 업데이트하고 뷰를 다시 그릴 수 있도록 알립니다.
                self.mapView.addOverlay(response.routes[0].polyline, level: .aboveRoads)
                self.objectWillChange.send()
            }
        }
    }

    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        if let friendName = overlay.title,
           let travelTime = travelInfoDictionary[friendName ?? "nobody"],
           let index = Array(travelInfoDictionary.keys).firstIndex(of: friendName ?? "nobody") {
            // travelTimeColors 배열에서 색상 할당
            renderer.strokeColor = travelTimeColors[index % travelTimeColors.count]
        } else {
            // travelTimeColors 배열을 모두 사용한 경우, 랜덤 색상 사용
            renderer.strokeColor = travelTimeColors.randomElement() ?? .black
        }
        renderer.lineWidth = 4.0
        return renderer
    }
}

// 재승 작성, 위도,경도로 미터 구하는 함수
func degreesToRadians(_ degrees: Double) -> Double {
    return degrees * .pi / 180.0
}

func calculateDistanceInMeters(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    let earthRadius = 6371000.0 // 지구의 반경 (미터)

    let lat1 = degreesToRadians(x1)
    let lon1 = degreesToRadians(y1)
    let lat2 = degreesToRadians(x2)
    let lon2 = degreesToRadians(y2)

    let dLat = lat2 - lat1
    let dLon = lon2 - lon1

    let a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2)
    let c = 2 * atan2(sqrt(a), sqrt(1-a))

    let distance = earthRadius * c

    return distance
}
