//
//  FriendsLocationMapView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/21.
//

import SwiftUI
import MapKit

struct FriendsLocationMapView: View {
    @ObservedObject var viewModel: FriendsLocationMapViewModel

    var body: some View {
        NavigationStack {
            Map(coordinateRegion: $viewModel.region,
                showsUserLocation: true,
                userTrackingMode: .constant(.follow),
                annotationItems: viewModel.destination + viewModel.friendsLocation) { place in
                
                MapAnnotation(coordinate: place.coordinate) {
                    PlaceDestinationView(title: place.title)
                }
            }
            .onAppear {
                viewModel.calculateRegion()
            }
        }
    }
}


#Preview {
    FriendsLocationMapView(viewModel: FriendsLocationMapViewModel())
}
