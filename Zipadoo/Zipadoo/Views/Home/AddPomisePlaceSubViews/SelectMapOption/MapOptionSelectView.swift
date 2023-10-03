//
//  MapOptionSelectView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI

// MARK: - 상단탭바 뷰 모델
/// 상단탭바 뷰 모델
struct MapOptionSelectView: View {
    var mapOptions: MapOption
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        VStack {
            switch mapOptions {
            case .click:
                MapView(promiseLocation: $promiseLocation)
            case .search:
                NewMapView(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, promiseLocation: $promiseLocation)
            }
        }
    }
}

#Preview {
    MapOptionSelectView(mapOptions: .click, isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청")))
}
