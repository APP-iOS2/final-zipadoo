//
//  MapView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 직접 장소 설정할 수 있는 옵션의 맵뷰
/// 현재 MapView와 NewMapView 간의 버전이 서로 다르기 때문에 우선 두가지 옵션을 선택할 수 있도록 구현
/// 두가지 기능을 합칠 수 있는 방법을 찾을 경우 도입 시도해볼 예정
struct MapView: View {
    @Namespace var mapScope
    @Environment(\.dismiss) private var dismiss
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    /// 초기 위치 값
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    /// 주소 값
    @State var address = ""
    /// 화면 클릭 값(직접설정맵뷰)
    @State private var selectedPlace: Bool = false

    @Binding var promiseLocation: PromiseLocation
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [promiseLocation]) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        PlaceMarkerCell()
                            .offset(x: 0, y: -50)
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Button {
                                if let userLocation = locationManager.location?.coordinate {
                                    withAnimation {
                                        region.center = userLocation
                                        makingKorAddress()
                                    }
                                }
                            } label: {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .bold()
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black, radius: 3)
                            }
                            Spacer()
                        }
                        .safeAreaPadding(.top, 50)
                        .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 15)
                            .overlay {
                                VStack {
                                    Spacer()
                                    
                                    if selectedPlace == true {
                                        Text(promiseLocation.address)
                                            .font(.title3)
                                    } else {
                                        Text("약속 장소를 선택해 주세요")
                                            .font(.title3)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        promiseLocation = addLocationStore.setLocation(
                                            latitude: promiseLocation.latitude,
                                            longitude: promiseLocation.longitude,
                                            address: promiseLocation.address)
                                        dismiss()
                                    } label: {
                                        Text("장소 선택하기")
                                            .frame(width: 290, height: 20)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 5))
                                    .padding(.bottom, 10)
                                }
                            }
                    }
                }
                .padding(.bottom, 30)
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            .onTapGesture {
                makingKorAddress()
                selectedPlace = true
            }
        }
    }
    
    func makingKorAddress() {
        let touchPoint = region.center
        promiseLocation = PromiseLocation(latitude: touchPoint.latitude, longitude: touchPoint.longitude, address: promiseLocation.address)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(
            latitude: touchPoint.latitude,
            longitude: touchPoint.longitude),
            preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
                promiseLocation.address = [ placemark.locality,
                            placemark.thoroughfare,
                            placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
            }
        }
    }
}

#Preview {
    MapView(promiseLocation: .constant(PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청")))
}
