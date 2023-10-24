//
//  PreviewPlaceOnMap.swift
//  Zipadoo
//
//  Created by 김상규 on 10/9/23.
//

import SwiftUI
import MapKit

/// 약속 등록자가 자신이 설정한 약속장소에 대해 확인할 수 있는 맵뷰
struct PreviewPlaceOnMap: View {
    /// 선택한 약속장소에 대한 카메라 포지션 값
    @State private var position: MapCameraPosition = MapCameraPosition.automatic
    @ObservedObject var promiseViewModel: PromiseViewModel
    
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordXXX: Double
    @Binding var coordYYY: Double
    
    var body: some View {
        Map(position: $position, bounds: MapCameraBounds(maximumDistance: 2000)) {
            UserAnnotation()
            Annotation("", coordinate: CLLocationCoordinate2D(latitude: coordXXX, longitude: coordYYY)) {
                VStack {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(Color.white)
                            .stroke(Color.yellow, lineWidth: 2)
                            .frame(width: 150, height: 35)
                            .foregroundStyle(.yellow)
                            .overlay {
                                Text($destination.wrappedValue)
                                    .font(.footnote)
                                    .padding(.all, 12)
                                    .foregroundStyle(.black)
                            }
                        Image(systemName: "arrowtriangle.down.fill")
                            .resizable()
                            .frame(width: 5, height: 8, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.yellow)
                            .offset(x: 0, y: 22)
                    }
                    .padding(.bottom)
                    
                    AnnotationMarker()
                }
                .offset(x: 0, y: -10)
            }
        }
        .onAppear {
//            destination = promiseLocation.destination
//            address = promiseLocation.address
//            coordXXX = promiseLocation.latitude
//            coordYYY = promiseLocation.longitude
//            
            position = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $coordXXX.wrappedValue, longitude: $coordYYY.wrappedValue), latitudinalMeters: 2000, longitudinalMeters: 2000))
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
//    PreviewPlaceOnMap(promiseViewModel: PromiseViewModel())
//    PreviewPlaceOnMap(promiseViewModel: .constant(PromiseLocation(destination: "서울시청", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
