//
//  FriendsLocationView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/25.
//

import SwiftUI
import MapKit

struct FriendsLocationMapView: View {
    @StateObject var viewModel = FriendsLocationMapViewModel()
    
    var body: some View {
        VStack {
            MapViewContainer(viewModel: viewModel)
                .onAppear {
                    viewModel.addDestinationPin()
                    viewModel.addFriendPinsAndCalculateTravelTimes()
                    
                    let locations = [viewModel.destinationLocation] + viewModel.friendsLocation.filter { $0.isMe }
                    
                    if let centerCoordinate = calculateCenterCoordinate(for: locations) {
                        
                        viewModel.region = MKCoordinateRegion(
                            center: centerCoordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        )
                    }
                }
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    // 중앙 좌표를 계산하는 함수
    private func calculateCenterCoordinate(for locations: [Location]) -> CLLocationCoordinate2D? {
        guard !locations.isEmpty else { return nil }
        
        var totalLatitude: CLLocationDegrees = 0.0
        var totalLongitude: CLLocationDegrees = 0.0
        
        for location in locations {
            totalLatitude += location.coordinate.latitude
            totalLongitude += location.coordinate.longitude
        }
        
        let averageLatitude = totalLatitude / CLLocationDegrees(locations.count)
        let averageLongitude = totalLongitude / CLLocationDegrees(locations.count)
        
        return CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude)
    }
}


#Preview {
    FriendsLocationMapView()
}
