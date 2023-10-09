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
    @State private var sort: String = "accuracy"
    /// 거리로 부터 5000m내의 검색결과 제공(잘 안되는것 같음)
    @State private var radius: Int = 5000
    /// 장소에 대한 URL 값 (카카오맵 기반)
    @State private var placeURL: String?
    /// 검색 결과 리스트의 i 버튼 클릭 값
    @State private var clickedPlaceInfo: Bool = false
    
    @Binding var isClickedPlace: Bool
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordX: Double
    @Binding var coordY: Double
    @Binding var selectedPlacePosition: CLLocationCoordinate2D?
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        VStack {
            HStack {
                TextField("키워드를 입력하세요", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    searching = true
                    isClickedPlace = false
                    searchOfKakaoLocal.searchKLPlace(keyword: searchText, currentPoiX: String(LocationManager().location?.coordinate.latitude ?? 0.0), currentPoiY: String(LocationManager().location?.coordinate.longitude ?? 0.0), radius: radius, sort: sort)
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
                                coordX = xValue
                                coordY = yValue
                                selectedPlacePosition = CLLocationCoordinate2D(latitude: coordX, longitude: coordX)
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
                            print("주소: \(address)")
                            print("장소 위도: \(promiseLocation.latitude)")
                            print("장소 경도: \(promiseLocation.longitude)")
                            print("거리: \(result.distance)")
                            
                            isClickedPlace = true
                            searching = false
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
                                                .foregroundColor(.gray)
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
                .navigationBarBackButtonHidden(true)
            } else {
                
            }
        }
    }
}

#Preview {
    SearchBarCell(isClickedPlace: .constant(false), destination: .constant("장소명"), address: .constant("주소"), coordX: .constant(0.0), coordY: .constant(0.0), selectedPlacePosition: .constant(CLLocationCoordinate2D(latitude: 37.39570088983171, longitude: 127.1104335101161)), promiseLocation: .constant( PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}

extension String: Identifiable {
    public var id: String { self }
}
