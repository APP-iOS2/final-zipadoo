//
//  OneMapView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/12/23.
//

import SwiftUI
import MapKit

/// 장소검색 옵션(직접설정, 장소검색)을 하나의 맵뷰를 통해 동작하는 맵뷰
struct OneMapView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var promiseViewModel: PromiseViewModel
    /// 연관된 값들을 한 공간에 이름을 지어 모아둔 공간, mapControls를 사용하기 위해 호출함
    @Namespace var mapScope
    /// 카카오 로컬 장소검색을 위한 클래스
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 지도의 카메라 포지션  값
    @State private var cameraPosition: MapCameraPosition = .userLocation(followsHeading: false, fallback: .automatic)
    /// 장소 검색에서 나온 리스트에서 클릭한 장소에 대한 카메라 포지션 값
    @State private var placePosition: MapCameraPosition = .camera(MapCamera(
        centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 36.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9880),
        distance: 2500
        )
    )
    /// 클릭한 장소에 대한 위치 값
    @State private var pinLocation: CLLocationCoordinate2D? = nil
    /// 직접 클릭한 장소명에 대해 사용자가 입력할 수 있는 값
    @State private var placeOfText: String = ""

    /// 약속장소 장소명 값
    @Binding var destination: String
    /// 약속장소 주소 값
    @Binding var address: String
    /// 클릭한 장소에 대한 위치 값
    @State private var selectedPlacePosition: CLLocationCoordinate2D?
    /// 약속장소 위도
    @Binding var coordXXX: Double
    /// 약속장소 경도
    @Binding var coordYYY: Double
    /// 화면을 클릭해서 장소를 선택한 값
    @State private var selectedPlace: Bool = false
    /// 장소검색 이후 장소를 선택한 값
    @State private var isClickedPlace: Bool = false
    /// 장소 검색을 사용한 후 장소 추가 버튼을 입력한 값
    @State private var addLocationButton: Bool = false
    
    @Binding var sheetTitle: String
    
//    @Binding var promiseLocation: PromiseLocation
    
    /// 클릭한 장소에 대한 위치 값을 약속장소로 지정하기 위해 사용하는 클래스
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                MapReader { reader in
                    // 맵뷰의 디폴트 값은 사용자의 위치를 보여줌
                    Map(position: $cameraPosition, scope: mapScope) {
                        UserAnnotation()
                        // 장소검색 이후 장소를 선택한 값이 true일 경우 해당장소 위치에 해당장소의 장소명이 포함된 Annotation을 보여줌
                        if isClickedPlace == true {
                            Annotation(destination, coordinate: CLLocationCoordinate2D(latitude: coordXXX, longitude: coordYYY)) {
                                AnnotationCell()
                                    .offset(x: 0, y: -10)
                            }
                        } else { // 장소검색 이후 장소를 선택한 값이 false일 경우
                            if selectedPlace == true { // 화면을 클릭해서 장소를 선택한 값이 true일 경우 해당 장소 위치에 해당장소의 주소가 포함된 Annotation을 보여줌
                                if let pl = pinLocation {
                                    Annotation(address, coordinate: pl) {
                                        AnnotationCell()
                                            .offset(x: 0, y: -10)
                                    }
                                    // 사용자의 현위치에 대한 Annotation을 보여줌
                                    UserAnnotation()
                                }
                            }
                            UserAnnotation()
                        }
                    }
                    .mapStyle(.standard(pointsOfInterest: .all, showsTraffic: true)) // mapStyle에 대해 지정함
                    .mapControls {
                        MapCompass(scope: mapScope)
                            .mapControlVisibility(.hidden) // MapCompass가 중복되게 보여져서 처음 나오는 MapCompass를 숨김
                    }
                    .onTapGesture(perform: { screenCoord in // 맵뷰 화면을 터치하였을 경우의 이벤트 - 화면을 터치하였을 때 MapReader를 통해 터치한 곳의 값과 맵뷰의 값을 변환시켜 위치 값을 알아냄
                        
                        if isClickedPlace != true { // 우선 장소검색 이후 장소를 선택한 값이 false여야 되며
                            selectedPlace = true // 화면을 클릭해서 장소를 선택한 값을 true로 지정
                            pinLocation = reader.convert(screenCoord, from: .local)
                            coordXXX = pinLocation?.latitude ?? 36.5665
                            coordYYY = pinLocation?.longitude ?? 126.9880
                            
                            // 가져온 위치값을 통해 해당 위치에 대한 주소를 한국 버전으로 변환시켜줌
                            let geocoder = CLGeocoder()
                            geocoder.reverseGeocodeLocation(CLLocation(
                                latitude: pinLocation?.latitude ?? 36.5665,
                                longitude: pinLocation?.longitude ?? 126.9880),
                                preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
                                if let placemark = placemarks?.first {
                                    address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
                                }
                            }
//                            isClickedPlace = false
                            if let pinLocation {
                                print("tap: screen \(screenCoord), location \(pinLocation)")
                            }
                            print("coordX: \(coordXXX) / coordY: \(coordYYY)")
                        }
                    })
                }
                if isClickedPlace == true { // 화면을 클릭해서 장소를 선택한 값이 true일 경우, 해당 옵션의 장소선택 결정뷰를 띄워줌
                    AddPlaceButtonCell(promiseViewModel: promiseViewModel, isClickedPlace: $isClickedPlace, placeOfText: $placeOfText, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY)
//                    AddPlaceButtonCell(isClickedPlace: $isClickedPlace, placeOfText: $placeOfText, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, promiseLocation: $promiseLocation)
                } else if selectedPlace == true {// 화면을 클릭해서 장소를 선택한 값이 true일 경우, 해당 옵션의 장소선택 결정뷰를 띄워줌
                    OneAddLocation(promiseViewModel: promiseViewModel, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, placeOfText: $placeOfText, selectedPlace: $selectedPlace, isClickedPlace: $isClickedPlace)
                } else {
                    
                }
            }
            .navigationTitle(sheetTitle)
            .navigationBarTitleDisplayMode(.inline)
            // 기본적으로 키보드를 보여지지 않게 함
            .onTapGesture {
                hideKeyboard()
            }
            // 맵뷰의 카메라가 바뀌어지게 해줌
            .onMapCameraChange(frequency: .onEnd) {
                // transform() 함수 호출을 제거하고 selectedPlacePosition을 직접 갱신
                if isClickedPlace == true {
                    placePosition = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedPlacePosition?.latitude ?? 37.5665, longitude: selectedPlacePosition?.longitude ?? 126.9780), distance: 2500))
                }
            }
            // 맵컨트롤 버튼들을 우츨 상단에 위치시킴
            .overlay(alignment: .topTrailing) {
                VStack {
                    MapUserLocationButton(scope: mapScope) // 사용자의 현재 위치로 이동시키는 버튼
                        .mapControlVisibility(.visible)
                    MapPitchToggle(scope: mapScope) // 지도의 차원을 정할 수 있는 버튼(2D, 3D)
                        .mapControlVisibility(.visible)
                    MapCompass(scope: mapScope) // 나침반 버튼
                        .mapControlVisibility(.visible)
                }
                .buttonBorderShape(.roundedRectangle)
                .padding(.trailing, 5)
                .padding(.top, 5)
            }
            .mapScope(mapScope) // SwiftUI가 맵 컨트롤을 연관된 맵에 연결하는 데 사용하는 mapScope를 생성
            
            // 검색창을 하단에 위치시킴
            .safeAreaInset(edge: .bottom) {
                HStack {
                    Spacer()
                    SearchBarCell(promiseViewModel: promiseViewModel, selectedPlace: $selectedPlace, isClickedPlace: $isClickedPlace, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, selectedPlacePosition: $selectedPlacePosition)
                    Spacer()
                }
                .background(.ultraThinMaterial)
            }
            // placePostion의 변화할 때마다 cameraPosition의 값을 placePosition의 값과 같게 함
            .onChange(of: placePosition) {
                    cameraPosition = placePosition
            }
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
        // 맵뷰가 사라졌을 때 해당 값들을 false로 지정함(나왔다가 다시 들어왔을 시 저장된 값들이 그대로 표시되지 않게 초기화 시키는 용도)
        .onDisappear {
            isClickedPlace = false
            selectedPlace = false
        }
    }
}

//#Preview {
//    OneMapView(promiseViewModel: PromiseViewModel(), destination: .constant(""), address: .constant(""), sheetTitle: .constant(""))
//}
