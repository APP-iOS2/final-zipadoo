//
//  NewMapView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit

// MARK: - 검색 기능을 통해 장소 설정할 수 있는 옵션의 맵뷰
/// 현재 MapView와 NewMapView 간의 버전이 서로 다르기 때문에 우선 두가지 옵션을 선택할 수 있도록 구현
/// 두가지 기능을 합칠 수 있는 방법을 찾을 경우 도입 시도해볼 예정
struct NewMapView: View {
    @Namespace var mapScope
    
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 유저의 현재위치 카메라 좌표 값
    @State var userPosition: MapCameraPosition = .userLocation(followsHeading: true, fallback: .automatic)
    /// 클릭한 장소에 대한 카메라 포지션 값
    @State var placePosition: MapCameraPosition = .automatic
    /// placePosition값을 넣기 위한 대한 카메라 포지션 값
    @State var movePosition: MapCameraPosition = .automatic
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
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $userPosition, bounds: cameraBounds, scope: mapScope) {
                    UserAnnotation()
                    
                    if isClickedPlace == true {
                        Annotation(destination, coordinate: movePosition.region?.center ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)) {
                            AnnotationCell()
                        }
                        UserAnnotation()
                        
                    } else {
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
            .onAppear {
                CLLocationManager().requestWhenInUseAuthorization()
            }
            .onChange(of: placePosition) {
                withAnimation {
                    userPosition = .automatic
                }
            }
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
        }
    }
}

#Preview {
    NewMapView(destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}
