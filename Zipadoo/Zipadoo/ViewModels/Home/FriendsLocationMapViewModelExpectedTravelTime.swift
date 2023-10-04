////
////  FriendsLocationMapViewModelExpectedTravelTime.swift
////  Zipadoo
////
////  Created by Handoo Jeong on 2023/10/04.
////
//
//import Foundation
//import SwiftUI
//import MapKit
//
//class FriendsLocationMapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
//    @Published var travelTimesText: [String: (String, String)] = [:]
//    @State var travelTimes: [String: TimeInterval] = [:]
//
//    var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(),
//        span: MKCoordinateSpan()
//    )
//
//    private let mapView = MKMapView()
//
//    let destinationLocation: Location = Location(
//        coordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
//        title: "약속장소",
//        imgString: "flag",
//        isMe: false
//    )
//
//    let friendsLocation: [Location] = [
//        Location(
//            coordinate: CLLocationCoordinate2D(latitude: 37.437453, longitude: 127.002293),
//            title: "정한두",
//            imgString: "dragon",
//            isMe: true
//        ),
//        Location(
//            coordinate: CLLocationCoordinate2D(latitude: 37.547551, longitude: 127.080315),
//            title: "임병구",
//            imgString: "bear",
//            isMe: false
//        ),
//        Location(
//            coordinate: CLLocationCoordinate2D(latitude: 37.536981, longitude: 126.999426),
//            title: "윤해수",
//            imgString: "rabbit",
//            isMe: false
//        )
//    ]
//
//    override init() {
//        super.init()
//        mapView.delegate = self
//    }
//
//    func makeMapView() -> MKMapView {
//        return mapView
//    }
//
//    func removeAnnotationsAndOverlays() {
//        mapView.removeAnnotations(mapView.annotations)
//        mapView.removeOverlays(mapView.overlays)
//    }
//
//    func addDestinationPin() {
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.coordinate = destinationLocation.coordinate
//        destinationAnnotation.title = destinationLocation.title
//        mapView.addAnnotation(destinationAnnotation)
//    }
//
//    func addFriendPinsAndCalculateTravelTimes() {
//        let myLocation = friendsLocation.first(where: { $0.isMe })
//
//        for friendLocation in friendsLocation where friendLocation.isMe == false {
//            let requestAnnotation = MKPointAnnotation()
//            requestAnnotation.coordinate = friendLocation.coordinate
//            requestAnnotation.title = friendLocation.title
//            mapView.addAnnotation(requestAnnotation)
//
//            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
//            let friendPlacemark = MKPlacemark(coordinate: friendLocation.coordinate)
//
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = MKMapItem(placemark: friendPlacemark)
//            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
//            directionRequest.transportType = .automobile
//
//            let directions = MKDirections(request: directionRequest)
//            directions.calculate { [weak self] response, error in
//                guard let self = self, let response = response else { return }
//
//                let route = response.routes[0]
//                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//
//                let friendName = friendLocation.title
//                let expectedTravelTime = route.expectedTravelTime
//
//                self.travelTimes[friendName] = expectedTravelTime
//
//                let formattedTime = self.formatTravelTime(expectedTravelTime)
//                self.travelTimesText[friendName] = (formattedTime, friendLocation.imgString)
//            }
//        }
//
//        if let myLocation = myLocation {
//            let requestAnnotation = MKPointAnnotation()
//            requestAnnotation.coordinate = myLocation.coordinate
//            requestAnnotation.title = myLocation.title
//            mapView.addAnnotation(requestAnnotation)
//
//            let destinationPlacemark = MKPlacemark(coordinate: destinationLocation.coordinate)
//            let friendPlacemark = MKPlacemark(coordinate: myLocation.coordinate)
//
//            let directionRequest = MKDirections.Request()
//            directionRequest.source = MKMapItem(placemark: friendPlacemark)
//            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
//            directionRequest.transportType = .automobile
//
//            let directions = MKDirections(request: directionRequest)
//            directions.calculate { [weak self] response, error in
//                guard let self = self, let response = response else { return }
//
//                let route = response.routes[0]
//                self.mapView.addOverlay(route.polyline, level: .aboveRoads)
//
//                let friendName = myLocation.title
//                let expectedTravelTime = route.expectedTravelTime
//
//                self.travelTimes[friendName] = expectedTravelTime
//
//                let formattedTime = self.formatTravelTime(expectedTravelTime)
//                self.travelTimesText[friendName] = (formattedTime, myLocation.imgString)
//            }
//        }
//    }
//
//    private func formatTravelTime(_ timeInterval: TimeInterval) -> String {
//        let minutes = Int(timeInterval / 60)
//        return "\(minutes) min"
//    }
//
//    // MKMapViewDelegate methods
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//        renderer.strokeColor = getRandomColor()
//        renderer.lineWidth = 4.0
//        return renderer
//    }
//
//    private func getRandomColor() -> UIColor {
//        let randomRed = CGFloat.random(in: 0...1)
//        let randomGreen = CGFloat.random(in: 0...1)
//        let randomBlue = CGFloat.random(in: 0...1)
//        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
//    }
//}
//
