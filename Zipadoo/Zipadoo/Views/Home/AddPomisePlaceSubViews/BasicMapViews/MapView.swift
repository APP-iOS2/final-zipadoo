//
//  MapView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import MapKit
import CoreLocation
import Alamofire

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
    
    @State private var placeOfText = ""
    /// 장소명 값
    @Binding var destination: String
    /// 주소 값
    @Binding var address: String
    /// 약속장소 위도
    @Binding var coordX: Double
    /// 약속장소 경도
    @Binding var coordY: Double
    /// 화면 클릭 값(직접설정맵뷰)
    @State private var selectedPlace: Bool = false
    
    @Binding var isClickedPlace: Bool
    @Binding var promiseLocation: PromiseLocation
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [promiseLocation]) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)) {
                        if selectedPlace == true {
                            PlaceMarkerCell()
                                .offset(x: 0, y: -50)
                        }
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
//                                        getAddressInfo()
                                        makingKorAddress()
                                    }
                                    selectedPlace = true
                                }
                            } label: {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .bold()
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black, radius: 1)
                            }
                            Spacer()
                        }
                        .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 15)
                            .overlay {
                                VStack {
                                    Spacer()
                                    
                                    if selectedPlace == true {
                                        TextField(address, text: $placeOfText)
                                            .textFieldStyle(.roundedBorder)
                                            .padding(.horizontal)
                                            .frame(height: 30)
//                                            .font(.title3)
                                    } else {
                                        Text("약속 장소를 선택해 주세요")
                                            .font(.title3)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        // 텍스트필드에서 입력이 없을 시 임의로 주소를 장소명으로,
                                        // 입력이 있을 시 입력한 텍스트를 장소명으로 지정
                                        if placeOfText == "" {
                                            destination = address
                                        } else {
                                            destination = placeOfText
                                        }
                                        isClickedPlace = false
                                        promiseLocation = addLocationStore.setLocation(destination: destination, address: address, latitude: coordX, longitude: coordY)
                                        print(destination)
                                        print(address)
                                        print(coordX)
                                        print(coordY)
                                        //                                        promiseLocation = addLocationStore.setLocation(
                                        //                                            latitude: promiseLocation.latitude,
                                        //                                            longitude: promiseLocation.longitude,
                                        //                                            address: promiseLocation.address)
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
                .padding(.bottom, 10)
            }
            .ignoresSafeArea(edges: .all)
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            .onTapGesture {
//                getAddressInfo()
                makingKorAddress()
                selectedPlace = true
            }
        }
    }
    
    func makingKorAddress() {
        let touchPoint = region.center
        coordX = touchPoint.latitude
        coordY = touchPoint.longitude
        promiseLocation = PromiseLocation(destination: destination, address: address, latitude: coordX, longitude: coordY)
        //        promiseLocation = PromiseLocation(latitude: touchPoint.latitude, longitude: touchPoint.longitude, address: promiseLocation.address)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(
            latitude: coordX,
            longitude: coordY),
            preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
//                destination = placemark.name ?? ""
                address = [ placemark.locality, placemark.thoroughfare, placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
            }
        }
    }
    
//    func getAddressInfo() {
//    let touchPoint = region.center
//        promiseLocation = PromiseLocation(destination: destination, address: address, latitude: touchPoint.latitude, longitude: touchPoint.longitude)
//
//        let headers: HTTPHeaders = [
//            "Authorization": "KakaoAK 191dedb3f0609fe5aab6a6dae502cee1"
//        ]
//
//        AF.request("https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(promiseLocation.longitude)&y=\(promiseLocation.latitude)", method: .get, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                print(value)
//                if let json = value as? [String: Any],
//                   let documents = json["documents"] as? [[String: Any]],
//                   let firstDocument = documents.first,
//                   let roadAddressInfo = firstDocument["road_address"] as? [String: Any],
//                   let addressName = roadAddressInfo["address_name"] as? String {
//                    print("Address Name: \(addressName)")
//                    self.address = addressName
//                } else {
//                    print("JSON 파일에 정보가 없습니다.")
//                    self.address = "주소를 찾을 수 없습니다."
//                }
//
//            case .failure(let error):
//                print(error)
//                self.address = "주소를 찾을 수 없습니다."
//            }
//        }
//    }
}

//#Preview {
//    MapView(destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), isClickedPlace: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "서울시청", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
