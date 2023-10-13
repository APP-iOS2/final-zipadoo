//
//  NewMapsView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/13/23.
//

import SwiftUI
import MapKit

struct NewMapsView: View {
    @Namespace var mapScope
    
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 유저의 현재위치 카메라 좌표 값
    @State private var userPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    /// 클릭한 장소에 대한 카메라 포지션 값
    @State private var placePosition: MapCameraPosition = .camera(MapCamera(
        centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
        distance: 3500
//            heading: 92,
//            pitch: 70
        )
    )
    /// placePosition값을 넣기 위한 대한 카메라 포지션 값
    @State private var movePosition: MapCameraPosition = .automatic
    /// 클릭한 장소에 대한 위치 값
    @State private var selectedPlacePosition: CLLocationCoordinate2D?
    /// 약속장소 위도
    @State private var coordX: Double = CLLocationManager().location?.coordinate.latitude ?? 37.5665
    /// 약속장소 경도
    @State private var coordY: Double = CLLocationManager().location?.coordinate.longitude ?? 126.9780
    
    /// 장소명 값
    @Binding var destination: String
    /// 주소 값
    @Binding var address: String
    /// 약속장소 위도
    
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $userPosition, scope: mapScope) {
                    UserAnnotation()
                    if isClickedPlace == true {
                        Annotation(destination, coordinate: CLLocationCoordinate2D(latitude: coordX, longitude: coordY)) {
                            AnnotationCell()
                        }
                        UserAnnotation()
                        
                    } else {
                        UserAnnotation()
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
                .mapStyle(.standard(pointsOfInterest: .all, showsTraffic: true))
                if isClickedPlace == true {
                    AddPlaceButtonCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
                        .padding(.bottom, 40)
                } else {
                    
                }
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    SearchBarCell(isClickedPlace: $isClickedPlace, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, selectedPlacePosition: $selectedPlacePosition, promiseLocation: $promiseLocation)
                    Spacer()
                }
                .background(.ultraThinMaterial)
            }
            .mapControls {
                MapUserLocationButton(scope: mapScope)
                    .mapControlVisibility(.visible)
                MapPitchToggle(scope: mapScope)
                    .mapControlVisibility(.visible)
                MapCompass(scope: mapScope)
                    .mapControlVisibility(.visible)
            }
            .mapScope(mapScope)
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .onChange(of: placePosition) {
                withAnimation {
                    userPosition = placePosition
                }
            }
            .onMapCameraChange(frequency: .continuous) {
                withAnimation {
                    selectedPlacePosition = CLLocationCoordinate2D(latitude: coordX, longitude: coordY)
                    // transform() 함수 호출을 제거하고 selectedPlacePosition을 직접 갱신
                    if isClickedPlace == true {
                        //   placePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ??  CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                        placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
                    } else {
                        //   placePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ??  CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                        placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
                        //                        userPosition = placePosition
                    }
                }
            }
        }
        .onDisappear {
            isClickedPlace = false
        }
    }
}

#Preview {
    NewMapView(destination: .constant(""), address: .constant(""), isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}
