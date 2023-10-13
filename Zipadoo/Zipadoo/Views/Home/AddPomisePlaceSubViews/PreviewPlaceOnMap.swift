//
//  PreviewPlaceOnMap.swift
//  Zipadoo
//
//  Created by 김상규 on 10/9/23.
//

import SwiftUI
import MapKit

struct PreviewPlaceOnMap: View {
    @State private var position: MapCameraPosition = MapCameraPosition.automatic
    @Binding var promiseLocation: PromiseLocation
    var body: some View {
        Map(position: $position, bounds: MapCameraBounds(maximumDistance: 2000)) {
            UserAnnotation()
            Annotation("", coordinate: CLLocationCoordinate2D(latitude: promiseLocation.latitude, longitude: promiseLocation.longitude)) {
                VStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white)
                        .stroke(Color.yellow, lineWidth: 2)
                        .frame(width: 150, height: 35)
                        .foregroundStyle(.yellow)
                        .overlay {
                            Text(promiseLocation.destination)
                                .font(.footnote)
                                .padding(.all, 12)
                                .foregroundStyle(.black)
                        }
                    AnnotationMarker()
                }
            }
        }
        .onAppear {
            position = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: promiseLocation.latitude, longitude: promiseLocation.longitude), latitudinalMeters: 2000, longitudinalMeters: 2000))
        }
        .mapControls {
            MapUserLocationButton()
                .mapControlVisibility(.visible)
            MapPitchToggle()
                .mapControlVisibility(.visible)
        }
    }
}

//#Preview {
//    PreviewPlaceOnMap(promiseLocation: .constant(PromiseLocation(destination: "서울시청", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
