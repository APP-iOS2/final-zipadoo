//
//  MapView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/04.
//

import Foundation
import SwiftUI
import MapKit

struct MapViewContainer: UIViewRepresentable {
    @ObservedObject var viewModel: FriendsLocationMapViewModel

    func makeUIView(context: Context) -> MKMapView {
        return viewModel.makeMapView()
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.region = viewModel.region

    }
}
