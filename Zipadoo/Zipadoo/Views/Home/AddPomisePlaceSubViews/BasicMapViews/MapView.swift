//
//  MapView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

//import SwiftUI
//import MapKit
//import CoreLocation
//
// MARK: - 직접 장소 설정할 수 있는 옵션의 맵뷰, 사용하지 않음(옵션보여주기에 대해 이슈 발생시 예비용)
/// 현재 MapView와 NewMapView 간의 버전이 서로 다르기 때문에 우선 두가지 옵션을 선택할 수 있도록 구현
/// 두가지 기능을 합칠 수 있는 방법을 찾을 경우 도입 시도해볼 예정
//struct MapView: View {
//    @Namespace var mapScope
//    @Environment(\.dismiss) private var dismiss
//    
//    var addLocationStore: AddLocationStore = AddLocationStore()
//    /// 초기 위치 값
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
//        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
//    
//    @State private var placeOfText = ""
//    
//    @State private var placeAPin = false
//    @State private var pinLocation: CLLocationCoordinate2D? = nil
//    /// 화면 클릭 값(직접설정맵뷰)
//    @State private var selectedPlace: Bool = false
//    @State private var cameraPosition: MapCameraPosition = .camera(
//        MapCamera(
//            centerCoordinate: CLLocationCoordinate2D(latitude: CLLocationManager().location?.coordinate.latitude ?? 37.5665, longitude: CLLocationManager().location?.coordinate.longitude ?? 126.9780),
//            distance: 3729
////            heading: 92,
////            pitch: 70
//        )
//    )
//    var cameraBounding: MapCameraBounds = MapCameraBounds(minimumDistance: 700)
//    
//    /// 장소명 값
//    @Binding var destination: String
//    /// 주소 값
//    @Binding var address: String
//    /// 약속장소 위도
//    @State private var coordXX: Double = 0.0
//    /// 약속장소 경도
//    @State private var coordYY: Double = 0.0
//    
//    @Binding var isClickedPlace: Bool
//    @Binding var promiseLocation: PromiseLocation
//    
//    let locationManager = CLLocationManager()
//    
//    var body: some View {
//        NavigationStack {
//            ZStack {
//                MapReader { reader in
//                    Map(position: $cameraPosition, bounds: cameraBounding, interactionModes: .all, scope: mapScope) {
//                        UserAnnotation()
//                        if let pl = pinLocation {
//                            Annotation(address, coordinate: pl) {
//                                AnnotationCell()
//                            }
//                            UserAnnotation()
//                        }
//                    }
//                    .mapStyle(.standard(elevation: .automatic))
//                    .mapControls {
//                        MapCompass(scope: mapScope)
//                            .mapControlVisibility(.hidden)
//                    }
//                    .onTapGesture(perform: { screenCoord in
//                        pinLocation = reader.convert(screenCoord, from: .local)
//                        placeAPin = false
//                        coordXX = pinLocation?.latitude ?? 36.5665
//                        coordYY = pinLocation?.longitude ?? 126.9880
//                           
//                        let geocoder = CLGeocoder()
//                        geocoder.reverseGeocodeLocation(CLLocation(
//                            latitude: pinLocation?.latitude ?? 36.5665,
//                            longitude: pinLocation?.longitude ?? 126.9880),
//                            preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
//                            if let placemark = placemarks?.first {
//                                address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
//                            }
//                        }
//                        selectedPlace = true
//                        if let pinLocation {
//                            print("tap: screen \(screenCoord), location \(pinLocation)")
//                        }
//                        print("coordX: \(coordXX) / coordY: \(coordYY)")
//                    })
//                }
//                .overlay(alignment: .topTrailing) {
//                    VStack {
//                        MapUserLocationButton(scope: mapScope)
//                        MapPitchToggle(scope: mapScope)
//                        MapCompass(scope: mapScope)
//                            .mapControlVisibility(.visible)
//                    }
//                    .padding(.top, 5)
//                    .padding(.trailing, 5)
//                    .buttonBorderShape(.roundedRectangle)
//                }
//                .mapScope(mapScope)
//    
//                VStack {
//                    
//                    Spacer()
//                    
//                    ZStack {
//                        RoundedRectangle(cornerRadius: 10)
//                            .foregroundStyle(.white)
//                            .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
//                            .shadow(radius: 15)
//                            .overlay {
//                                VStack {
//                                    Spacer()
//                                    if selectedPlace == true {
//                                        TextField(address, text: $placeOfText)
//                                            .textFieldStyle(.roundedBorder)
//                                            .padding(.horizontal)
//                                            .frame(height: 30)
//                                    } else {
//                                        Text("약속 장소를 선택해 주세요")
//                                            .font(.title3)
//                                            .foregroundStyle(.gray)
//                                    }
//                                    
//                                    Spacer()
//                                    
//                                    Button {
//                                        // 텍스트필드에서 입력이 없을 시 임의로 주소를 장소명으로,
//                                        // 입력이 있을 시 입력한 텍스트를 장소명으로 지정
//                                        if placeOfText == "" {
//                                            destination = address
//                                        } else {
//                                            destination = placeOfText
//                                        }
//                                        isClickedPlace = false
//                                        promiseLocation = addLocationStore.setLocation(destination: destination, address: address, latitude: coordXX, longitude: coordYY)
//                                        print(destination)
//                                        print(address)
//                                        print(coordXX)
//                                        print(coordYY)
//                                        dismiss()
//                                    } label: {
//                                        Text("장소 선택하기")
//                                            .frame(width: 290, height: 20)
//                                    }
//                                    .buttonStyle(.borderedProminent)
//                                    .buttonBorderShape(.roundedRectangle(radius: 5))
//                                    .padding(.bottom, 10)
//                                }
//                            }
//                    }
//                    .padding(.bottom, 30)
//                }
//                .padding(.bottom, 10)
//            }
//            .ignoresSafeArea(edges: .all)
//            .onAppear {
//                locationManager.requestWhenInUseAuthorization()
//            }
//        }
//    }
//}
//
//#Preview {
//    MapView(destination: .constant(""), address: .constant(""), isClickedPlace: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "서울시청", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
