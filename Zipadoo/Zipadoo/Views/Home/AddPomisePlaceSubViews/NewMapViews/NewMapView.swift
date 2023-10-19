//
//  NewMapView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit
// MARK: - 검색 기능을 통해 장소 설정할 수 있는 옵션의 맵뷰, 사용하지 않음(옵션보여주기에 대해 이슈 발생시 예비용)
/// 현재 MapView와 NewMapView 간의 버전이 서로 다르기 때문에 우선 두가지 옵션을 선택할 수 있도록 구현
/// 두가지 기능을 합칠 수 있는 방법을 찾을 경우 도입 시도해볼 예정
//struct NewMapView: View {
//    @Namespace var mapScope
//    
//    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
//    /// 유저의 현재위치 카메라 좌표 값
//    @State private var userPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
//    /// 클릭한 장소에 대한 카메라 포지션 값
//    @State private var placePosition: MapCameraPosition = .camera(MapCamera(
//        centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
//        distance: 3500
//        //            heading: 92,
//        //            pitch: 70
//    )
//    )
//    /// placePosition값을 넣기 위한 대한 카메라 포지션 값
//    @State private var movePosition: MapCameraPosition = .automatic
//    /// 클릭한 장소에 대한 위치 값
//    @State private var selectedPlacePosition: CLLocationCoordinate2D?
//    /// 약속장소 위도
//    @State private var coordX: Double = CLLocationManager().location?.coordinate.latitude ?? 37.5665
//    /// 약속장소 경도
//    @State private var coordY: Double = CLLocationManager().location?.coordinate.longitude ?? 126.9780
//    
//    /// 장소명 값
//    @Binding var destination: String
//    /// 주소 값
//    @Binding var address: String
//    /// 약속장소 위도
//    
//    @Binding var isClickedPlace: Bool
//    @Binding var addLocationButton: Bool
//    @Binding var promiseLocation: PromiseLocation
//    
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                Map(position: $userPosition, scope: mapScope) {
//                    UserAnnotation()
//                    if isClickedPlace == true {
//                        Annotation(destination, coordinate: CLLocationCoordinate2D(latitude: coordX, longitude: coordY)) {
//                            AnnotationCell()
//                        }
//                        UserAnnotation()
//                    } else {
//                        UserAnnotation()
//                    }
//                }
//                .mapControls {
//                    MapCompass(scope: mapScope)
//                        .mapControlVisibility(.hidden)
//                }
//                .onTapGesture {
//                    hideKeyboard()
//                }
//                .mapStyle(.standard(pointsOfInterest: .all, showsTraffic: true))
//                if isClickedPlace == true {
//                    AddPlaceButtonCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
//                        .padding(.bottom, 10)
//                } else {
//                    
//                }
//            }
//            .safeAreaInset(edge: .bottom) {
//                HStack {
//                    Spacer()
//                    SearchBarCell(isClickedPlace: $isClickedPlace, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, selectedPlacePosition: $selectedPlacePosition, promiseLocation: $promiseLocation)
//                    Spacer()
//                }
//                .background(.ultraThinMaterial)
//            }
//            .overlay(alignment: .topTrailing) {
//                VStack {
//                    MapUserLocationButton(scope: mapScope)
//                    MapPitchToggle(scope: mapScope)
//                    MapCompass(scope: mapScope)
//                        .mapControlVisibility(.visible)
//                }
//                .buttonBorderShape(.roundedRectangle)
//                .padding(.trailing, 5)
//                .padding(.top, 5)
//            }
//            .mapScope(mapScope)
//            .onChange(of: placePosition) {
//                userPosition = placePosition
//            }
//            .onMapCameraChange(frequency: .onEnd) {
//                // transform() 함수 호출을 제거하고 selectedPlacePosition을 직접 갱신
//                if isClickedPlace == true {
//                    placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
//                } else {
////                    placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 3500))
//                }
//            }
//        }
//        .onAppear {
//            CLLocationManager().requestWhenInUseAuthorization()
//        }
//    }
//}
//
//#Preview {
//    NewMapView(destination: .constant(""), address: .constant(""), isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
