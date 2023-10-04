//
//  FriendsLocationMapViewModelExpectedTravelTime.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/04.
//

import Foundation
import SwiftUI
import MapKit

class FriendsLocationMapViewModel: NSObject, ObservableObject, MKMapViewDelegate {
    @Published var travelTimesText: [String: (String, String)] = [:]
    @State var travelTimes: [String: TimeInterval] = [:]

    var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(),
        span: MKCoordinateSpan()
    )

    private let mapView = MKMapView()

    let destinationLocation: Location = Location(
        coordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
        title: "약속장소",
        imgString: "flag",
        isMe: false
    )

    let friendsLocation: [Location] = [
        Location(
            coordinate: CLLocationCoordinate2D(latitude: 37.437453, longitude: 127.002293),
            title: "정한두",
            imgString: "dragon",
            isMe: true
        ),
        Location(
            coordinate: CLLocationCoordinate2D(latitude: 37.547551, longitude: 127.080315),
            title: "임병구",
            imgString: "bear",
            isMe: false
        ),
        Location(
            coordinate: CLLocationCoordinate2D(latitude: 37.536981, longitude: 126.999426),
            title: "윤해수",
            imgString: "rabbit",
            isMe: false
        ),
        Location(
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

                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)

                let friendName = friendLocation.title
                let remainingDistance = route.distance

                self.travelTimes[friendName] = remainingDistance

                let formattedDistance = self.formatDistance(remainingDistance)
                self.travelTimesText[friendName] = (formattedDistance, friendLocation.imgString)
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

                let route = response.routes[0]
                self.mapView.addOverlay(route.polyline, level: .aboveRoads)

                let friendName = myLocation.title
                let remainingDistance = route.distance

                self.travelTimes[friendName] = remainingDistance

                let formattedDistance = self.formatDistance(remainingDistance)
                self.travelTimesText[friendName] = (formattedDistance, myLocation.imgString)
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
        renderer.strokeColor = getRandomColor()
        renderer.lineWidth = 4.0
        return renderer
    }

    private func getRandomColor() -> UIColor {
        let randomRed = CGFloat.random(in: 0...1)
        let randomGreen = CGFloat.random(in: 0...1)
        let randomBlue = CGFloat.random(in: 0...1)
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
}
