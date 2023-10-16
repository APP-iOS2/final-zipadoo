//
//  SearchbarCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 장소검색 검색창 뷰모델
/// 장소검색을 위한 검색창 뷰모델
struct SearchBarCell: View {
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 검색 키워드
    @State private var searchText: String = ""
    /// 검색버튼에 의한 리스트 도출 값
    @State var searching: Bool = false
    /// accuracy: 정렬기준
    @State private var sort: String = "accuracy" // distance
    /// 거리로 부터 5000m내의 검색결과 제공(잘 안되는것 같음)
    @State private var radius: Int = 5000
    /// 장소에 대한 URL 값 (카카오맵 기반)
    @State private var placeURL: String?
    /// 검색 결과 리스트의 i 버튼 클릭 값
    @State private var clickedPlaceInfo: Bool = false
    @State private var textFieldText: String = "키워드를 입력하세요."
    
    var locationManager: LocationManager = LocationManager()
    @Binding var selectedPlace: Bool
    @Binding var isClickedPlace: Bool
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordXXX: Double
    @Binding var coordYYY: Double
    @Binding var selectedPlacePosition: CLLocationCoordinate2D?
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        VStack {
            HStack {
                TextField(textFieldText, text: $searchText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    if searchText != "" {
                        searching = true
                        isClickedPlace = false
                        selectedPlace = false
                        searchOfKakaoLocal.searchKLPlace(keyword: searchText, currentPoiX: String(locationManager.location?.coordinate.latitude ?? 0.0), currentPoiY: String(locationManager.location?.coordinate.longitude ?? 0.0), radius: radius, sort: sort)
                        print("현재 사용자 위도(장소검색): \(locationManager.location?.coordinate.latitude ?? 0.0)")
                        print("현재 사용자 경도(장소검색): \(locationManager.location?.coordinate.longitude ?? 0.0)")
                    } else {
                        textFieldText = "한 글자 이상 입력해주세요."
                    }
                } label: {
                    ZStack {
                        Color.blue
                            .frame(width: 33, height: 33)
                            .clipShape(.buttonBorder)
                        Image(systemName: "magnifyingglass")
                    }
                }
                .tint(.white)
            }
            .padding()
            
            /// 검색버튼을 눌렀을 경우, searching값이 true가 되어 검색결과에 대한 리스트값 도출
            if searching == true {
                List(searchOfKakaoLocal.searchKakaoLocalDatas, id: \.place_name) { result in
                    VStack {
                        Button {
                            /// 클릭한 장소에 대한 위도경도 값을 변환하여 검색기능 맵뷰에 사용되는 promiseLocation 및 selectedPlacePosition 에 반영시킴
                            if let xValue = Double(result.y), let yValue = Double(result.x) {
                                coordXXX = xValue
                                coordYYY = yValue
                                selectedPlacePosition = CLLocationCoordinate2D(latitude: coordXXX, longitude: coordYYY)
                            } else {
                                print("변환 실패")
                            }
                            
                            /// 장소 이름 설정
                            destination = result.place_name
                            /// 주소명 설정
                            /// 장소에 대한 주소가 없을 시, 장소이름으로 장소에 대한 주소값 대체
                            if result.road_address_name == "" {
                                address = destination
                            } else {
                                address = result.road_address_name
                            }
                            
                            print("장소 이름: \(destination)")
                            print("카테고리: \(result.category_name)")
                            print("주소: \(address)")
                            print("장소 위도: \(selectedPlacePosition?.latitude ?? 0.0)")
                            print("장소 경도: \(selectedPlacePosition?.longitude ?? 0.0)")
                            print("거리: \(result.distance)")
                            
                            isClickedPlace = true
                            searchText = ""
                            textFieldText = "키워드를 입력하세요."
                            selectedPlace = false
                            searching = false
                            hideKeyboard()
                        } label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    VStack {
                                        HStack {
                                            Text(result.place_name)
                                                .font(.headline)
                                                .foregroundColor(.black)
                                            Text(result.category_group_name)
                                                .font(.caption).bold()
                                                .foregroundColor(.blue)
                                            Spacer()
                                        }
                                        .padding(.bottom, 5)
                                        
                                        HStack {
                                            Text(result.road_address_name)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                    
                                    /// ( i ) 버튼을 누르면 검색을 통해 얻은 url값으로 더 자세한 정보가 담긴 카카오맵 웹뷰 시트가 띄어짐
                                    Button {
                                        placeURL = result.place_url
                                        clickedPlaceInfo.toggle()
                                    } label: {
                                        Image(systemName: "info.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                    }
                                    .tint(.yellow)
                                    .fullScreenCover(item: $placeURL) { url in
                                        PlaceInfoWebView(urlString: url)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationBarBackButtonHidden(true)
            }
        }
    }
}

#Preview {
    SearchBarCell(selectedPlace: .constant(false), isClickedPlace: .constant(false), destination: .constant("장소명"), address: .constant("주소"), coordXXX: .constant(0.0), coordYYY: .constant(0.0),
        selectedPlacePosition: .constant(CLLocationCoordinate2D(latitude: 37.39570088983171, longitude: 127.1104335101161)),
        promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}

extension String: Identifiable {
    public var id: String { self }
}
