//
//  OneMapView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/12/23.
//

import SwiftUI
import MapKit

struct OneMapView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Namespace var mapScope
    
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 지도의 카메라 포지션  값
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    /// 클릭한 장소에 대한 카메라 포지션 값
    @State private var placePosition: MapCameraPosition = .camera(MapCamera(
        centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
        distance: 3700
        )
    )
    
//    @State private var cameraProsition: MapCameraPosition = .camera(
//        MapCamera(
//            centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
//            distance: 3729
//        )
//    )
    @State private var placeAPin: Bool = false
    @State private var pinLocation: CLLocationCoordinate2D? = nil
    @State private var placeOfText: String = ""
    
    /// 클릭한 장소에 대한 위치 값
    @State private var selectedPlacePosition: CLLocationCoordinate2D?
    /// 장소명 값
    @Binding var destination: String
    /// 주소 값
    @Binding var address: String
    /// 약속장소 위도
    @State private var coordXXX: Double = CLLocationManager().location?.coordinate.latitude ?? 37.5665
    /// 약속장소 경도
    @State private var coordYYY: Double = CLLocationManager().location?.coordinate.longitude ?? 126.9780
    /// 장소설정을 위한 터치값
    @State private var selectedPlace: Bool = false
    /// 장소검색을 위한 리스트 버튼 값
    @State private var isClickedPlace: Bool = false
    /// 장소 추가 버튼 입력값
    @State private var addLocationButton: Bool = false
    @Binding var promiseLocation: PromiseLocation
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { reader in
                    Map(position: $cameraPosition, scope: mapScope) {
                        UserAnnotation()
                        
                        if isClickedPlace == true {
                            Annotation(destination, coordinate: CLLocationCoordinate2D(latitude: coordXXX, longitude: coordYYY)) {
                                AnnotationCell()
                                    .offset(x: 0, y: -20)
                            }
                        } else {
                            if selectedPlace == true {
                                if let pl = pinLocation {
                                    Annotation(address, coordinate: pl) {
                                        AnnotationCell()
                                            .offset(x: 0, y: -10)
                                    }
                                    UserAnnotation()
                                }
                            }
                            UserAnnotation()
                        }
                    }
                    .mapStyle(.standard(pointsOfInterest: .all, showsTraffic: true))
                    .mapControls {
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.hidden)
                    }
                    .onTapGesture(perform: { screenCoord in
                        if isClickedPlace != true {
                            selectedPlace = true
                            pinLocation = reader.convert(screenCoord, from: .local)
                            placeAPin = false
                            coordXXX = pinLocation?.latitude ?? 36.5665
                            coordYYY = pinLocation?.longitude ?? 126.9880
                            
                            let geocoder = CLGeocoder()
                            geocoder.reverseGeocodeLocation(CLLocation(
                                latitude: pinLocation?.latitude ?? 36.5665,
                                longitude: pinLocation?.longitude ?? 126.9880),
                                preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
                                if let placemark = placemarks?.first {
                                    address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
                                }
                            }
                            isClickedPlace = false
                            if let pinLocation {
                                print("tap: screen \(screenCoord), location \(pinLocation)")
                            }
                            print("coordX: \(coordXXX) / coordY: \(coordYYY)")
                        }
                    })
                }
                if isClickedPlace == true {
                    AddPlaceButtonCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, promiseLocation: $promiseLocation)
                } else if selectedPlace == true {
                    OneAddLocation(destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, placeOfText: $placeOfText, selectedPlace: $selectedPlace, isClickedPlace: $isClickedPlace, promiseLocation: $promiseLocation)
                }
            }
            .onTapGesture {
                hideKeyboard()
            }
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    SearchBarCell(selectedPlace: $selectedPlace, isClickedPlace: $isClickedPlace, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, selectedPlacePosition: $selectedPlacePosition, promiseLocation: $promiseLocation)
                    Spacer()
                }
                .background(.ultraThinMaterial)
            }
            .overlay(alignment: .topTrailing) {
                VStack {
                    MapUserLocationButton(scope: mapScope)
                        .mapControlVisibility(.visible)
                    MapPitchToggle(scope: mapScope)
                        .mapControlVisibility(.visible)
                    MapCompass(scope: mapScope)
                        .mapControlVisibility(.visible)
                }
                .buttonBorderShape(.roundedRectangle)
                .padding(.trailing, 5)
                .padding(.top, 5)
            }
            .mapScope(mapScope)
            .onChange(of: placePosition) {
                    cameraPosition = placePosition
            }
            .onMapCameraChange(frequency: .onEnd) {
                // transform() 함수 호출을 제거하고 selectedPlacePosition을 직접 갱신
                if isClickedPlace == true {
                    placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
                }
//                else {
//                    //                    placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
//                }
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        .onDisappear {
            isClickedPlace = false
            selectedPlace = false
        }
    }
}

#Preview {
    OneMapView(destination: .constant(""), address: .constant(""), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}
