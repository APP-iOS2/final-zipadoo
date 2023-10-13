//
//  TestingMaps.swift
//  Zipadoo
//
//  Created by 김상규 on 10/12/23.
//

import SwiftUI
import MapKit

struct TestingMaps: View {
    @Environment(\.dismiss) private var dismiss
    
    @Namespace var mapScope
    
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 유저의 현재위치 카메라 좌표 값
    @State var userPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    /// 클릭한 장소에 대한 카메라 포지션 값
    @State var placePosition: MapCameraPosition = .automatic
    /// placePosition값을 넣기 위한 대한 카메라 포지션 값
    @State var movePosition: MapCameraPosition = .automatic
    
    @State private var cameraProsition: MapCameraPosition = .camera(
        MapCamera(
            centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
            distance: 3729
        )
    )
    @State var placeAPin = false
    @State var pinLocation: CLLocationCoordinate2D? = nil
    @State private var selectedPlace: Bool = false
    @State private var placeOfText = ""
    
    /// 카메라 높이
    @State var cameraBounds: MapCameraBounds = MapCameraBounds(minimumDistance: 500)
    /// 클릭한 장소에 대한 위치 값
    @State var selectedPlacePosition: CLLocationCoordinate2D?
    /// 장소명 값
    @Binding var destination: String
    /// 주소 값
    @Binding var address: String
    /// 약속장소 위도
    @Binding var coordX: Double
    /// 약속장소 경도
    @Binding var coordY: Double
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    @Binding var promiseLocation: PromiseLocation
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { reader in
                    Map(position: $userPosition, bounds: cameraBounds, scope: mapScope) {
                        UserAnnotation()
                        
                        if isClickedPlace == true {
                            Annotation(destination, coordinate: movePosition.region?.center ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)) {
                                AnnotationCell()
                            }
                        } else if selectedPlace == true {
                            if let pl = pinLocation {
                                Annotation(address, coordinate: pl) {
                                    AnnotationCell()
                                }
                                UserAnnotation()
                            }
                            UserAnnotation()
                        }
                    }
                    .mapControls {
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.hidden)
                    }
                    .onTapGesture(perform: { screenCoord in
                        pinLocation = reader.convert(screenCoord, from: .local)
                        placeAPin = false
                        coordX = pinLocation?.latitude ?? 36.5665
                        coordY = pinLocation?.longitude ?? 126.9880
                           
                        let geocoder = CLGeocoder()
                        geocoder.reverseGeocodeLocation(CLLocation(
                            latitude: pinLocation?.latitude ?? 36.5665,
                            longitude: pinLocation?.longitude ?? 126.9880),
                            preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
                            if let placemark = placemarks?.first {
                                address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
                            }
                        }
                        selectedPlace = true
                        if let pinLocation {
                            print("tap: screen \(screenCoord), location \(pinLocation)")
                        }
                        print("coordX: \(coordX) / coordY: \(coordY)")
                    })
                }
                .overlay(alignment: .topTrailing) {
                    VStack {
                        MapUserLocationButton(scope: mapScope)
                        MapPitchToggle(scope: mapScope)
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.visible)
                    }
                    .padding(.top)
                    .buttonBorderShape(.circle)
                }
                .mapScope(mapScope)

                .onTapGesture {
                    hideKeyboard()
                }
                if isClickedPlace == true {
                    AddPlaceButtonCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
                        .padding(.bottom, 40)
                } else {
                    if selectedPlace == true {
                        TestingsAddLocation(destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, placeOfText: $placeOfText, selectedPlace: $selectedPlace, isClickedPlace: $isClickedPlace, promiseLocation: $promiseLocation)
                    }
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
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
//            .onChange(of: placePosition) {
//                withAnimation {
//                    userPosition = .automatic
//                }
//            }
            .onMapCameraChange(frequency: .continuous) {
                withAnimation {
                    // transform() 함수 호출을 제거하고 selectedPlacePosition을 직접 갱신
                    if isClickedPlace == true {
                        selectedPlacePosition = CLLocationCoordinate2D(latitude: coordX, longitude: coordY)
                        //                        placePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ??  CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                        placePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), latitudinalMeters: 700, longitudinalMeters: 700))
                        movePosition = placePosition
                        
                    } else {
                        //                        placePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ??  CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)))
                        movePosition = .region(MKCoordinateRegion(center: selectedPlacePosition ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780), latitudinalMeters: 700, longitudinalMeters: 700))
                        //                        userPosition = placePosition
                    }
                }
            }
        }
        .onDisappear {
            isClickedPlace = false
            selectedPlace = false
        }
    }
}

#Preview {
    TestingMaps(destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}
