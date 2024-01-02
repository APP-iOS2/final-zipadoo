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
//    @ObservedObject var promiseViewModel: PromiseViewModel
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    /// 검색 키워드
    @State private var searchText: String = ""
    /// 검색버튼에 의한 리스트 도출 값
    @State var searching: Bool = false
    /// 거리로 부터 5km내의 검색결과 제공
    @State private var radius: Int = 5000
    /// 장소에 대한 URL 값 (카카오맵 기반)
    @State private var placeURL: String?
    /// 검색 결과 리스트의 i 버튼 클릭 값
    @State private var clickedPlaceInfo: Bool = false
    @State private var textFieldText: String = "키워드를 입력하세요."
    /// 내주변과 관련된 텍스트 표시 애니메이션 Bool값
    @State private var isTextVisible = false
    var locationManager: LocationManager = LocationManager()
    
    @Binding var isClickedDestination: String
    @Binding var selectedPlace: Bool
    @Binding var isClickedPlace: Bool
    @Binding var myLocation: Bool
    @Binding var address: String
    @Binding var coordXXX: Double
    @Binding var coordYYY: Double
    @Binding var selectedPlacePosition: CLLocationCoordinate2D?
    
    var body: some View {
        VStack {
            HStack {
                // 장소(키워드) 입력창
                TextField(textFieldText, text: $searchText)
                    .padding(.horizontal, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.primaryInvert2)
                            .frame(height: 33)
                    )
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                // Search 버튼
                Button {
                    if searchText != "" { // searchText가 빈 값이 아닐 경우 searching값을 true로 지정
                        searching = true
                        isClickedPlace = false
                        selectedPlace = false
                        // 카카오로컬 API를 활용하여 카카오로컬에 담긴 JSON파일과 통신하여 데이터를 불러옴
                        searchOfKakaoLocal.searchKLPlace(keyword: searchText, currentPoiX: myLocation ? String(locationManager.location?.coordinate.longitude ?? 0.0) : "0.0", currentPoiY: myLocation ? String(locationManager.location?.coordinate.latitude ?? 0.0) : "0.0", radius: myLocation ? radius : 0, sort: myLocation ? "distance" : "accuracy")
                        print("현재 사용자 위도(장소검색): \(locationManager.location?.coordinate.latitude ?? 0.0)")
                        print("현재 사용자 경도(장소검색): \(locationManager.location?.coordinate.longitude ?? 0.0)")
                    } else { // searchText가 빈 값일 경우 해당 텍스트를 보여줌
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
            .padding(5)
            .padding(.top, 10)
            
            /// 검색버튼을 눌렀을 경우, searching값이 true가 되어 검색결과에 대한 리스트값 도출
            if searching == true {
                HStack {
                    Button {
                        searching = false
                        searchText = ""
                        myLocation = false
                    } label: {
                        Text("취소")
                    }
                    .tint(.red)
                    .padding(.leading, 7)
                    
                    Spacer()
                    VStack {
                        if myLocation {
                            if isTextVisible {
                                Text("내 주변 5km 내 가까운 장소를 검색합니다.")
                                    .foregroundStyle(.gray)
                                    .font(.system(size: 11))
                                    .opacity(isTextVisible ? 1.0 : 0.0)
                                    .padding(.leading, 30)
                                    .onAppear {
                                        // 뷰가 나타날 때 타이머 시작
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            // 3초 후에 텍스트가 사라지도록 상태 업데이트
                                            withAnimation {
                                                isTextVisible = false
                                            }
                                        }
                                    }
                            }
                        }
                    }
                    Spacer()
                    
                    Text("내 주변")
                        .padding(.trailing, -5)
                    
                    Button {
                        withAnimation(nil) {
                            myLocation.toggle()
                        }
                        isTextVisible = true
                        searchOfKakaoLocal.searchKLPlace(keyword: searchText, currentPoiX: myLocation ? String(locationManager.location?.coordinate.longitude ?? 0.0) : "0.0", currentPoiY: myLocation ? String(locationManager.location?.coordinate.latitude ?? 0.0) : "0.0", radius: myLocation ? radius : 0, sort: myLocation ? "distance" : "accuracy")
                    } label: {
                        Image(systemName: myLocation ? "checkmark.square.fill" : "square")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 18, height: 18)
                    }
                    .tint(.mocha)
                    .padding(.trailing, 7)
                }
                .padding(.vertical, 3)
                
                if searchOfKakaoLocal.searchKakaoLocalDatas.isEmpty {
                    ContentUnavailableView(myLocation ? "내 주변 가까운 장소가 없습니다." : "검색 결과가 없습니다.", systemImage: "magnifyingglass", description: Text("다른 키워드로 검색해보세요."))
                        .padding(.bottom, 50)
                    
                    Spacer()
                    
                } else {
                    ScrollView {
                        VStack(spacing: 0) {
                                Divider()
                                    .frame(width: .infinity)
                                    .padding(.top, -1)
                            
                            ForEach(searchOfKakaoLocal.searchKakaoLocalDatas, id: \.place_name) { result in
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
                                        isClickedDestination = result.place_name
                                        /// 주소명 설정
                                        /// 장소에 대한 주소가 없을 시, 장소이름으로 장소에 대한 주소값 대체
                                        if result.road_address_name == "" {
                                            address = result.address_name
                                        } else {
                                            address = result.road_address_name
                                        }
                                        
                                        print("장소 이름: \(isClickedDestination)")
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
                                        myLocation = false
                                        hideKeyboard()
                                        
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    HStack {
                                                        Text(result.place_name.count >= 13 || (result.place_name.count + category(categoryName: result.category_name).count > 21) || (result.place_name.count >= 14 && category(categoryName: result.category_name).count >= 8) ? result.place_name.prefix(12) + "..." : result.place_name)
                                                            .font(.system(size: 16)).bold()
                                                        
                                                        Text(category(categoryName: result.category_name))
                                                            .font(.system(size: 9)).bold()
                                                            .foregroundColor(.blue)
                                                            .padding(.bottom, -5)
                                                            .padding(.leading, -7)
                                                        
                                                        Spacer()
                                                    }
                                                    .foregroundColor(.primary)
                                                    
                                                    Text(result.road_address_name.isEmpty ? result.address_name : result.road_address_name)
                                                        .font(.system(size: 13))
                                                        .foregroundStyle(.gray)
                                                }
                                                
                                                if myLocation {
                                                    Text("\(formatDistance(Double(result.distance) ?? 0.0))")
                                                        .font(.system(size: 13))
                                                        .foregroundStyle(.gray)
                                                }
                                                /// ( i ) 버튼을 누르면 검색을 통해 얻은 url값으로 더 자세한 정보가 담긴 카카오맵 웹뷰 시트가 띄어짐
                                                Button {
                                                    placeURL = result.place_url
                                                    clickedPlaceInfo.toggle()
                                                } label: {
                                                    Image(systemName: "info.circle.fill")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 35)
                                                }
                                                .tint(.mocha)
                                                .fullScreenCover(item: $placeURL) { url in
                                                    PlaceInfoWebView(urlString: url)
                                                }
                                            }
                                        }
                                    }
                                }
                                .padding(.horizontal, 15)
                                .padding(.vertical)
                                
                                Divider()
                                    .frame(width: .infinity)
                                    .padding(.bottom, -1)
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollBounceBehavior(.basedOnSize)
                    .background {
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(Color.primaryInvert)
                    }
                    .padding(.horizontal, 5)
                    .padding(.bottom)
                }
            }
        }
    }
    /// 제일 마지막 부분의 카테고리를 표시하게 해주는 함수
    private func category(categoryName: String) -> String {
        if let greaterThanIndex = categoryName.lastIndex(of: ">") {
            let firstI = categoryName.index(after: greaterThanIndex)
            let lastI = categoryName.index(before: categoryName.endIndex)
            return String(categoryName[firstI...lastI])
        } else {
            return categoryName
        }
    }
    
    private func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}

#Preview {
    SearchBarCell(/*promiseViewModel: PromiseViewModel(),*/ isClickedDestination: .constant(""), selectedPlace: .constant(false), isClickedPlace: .constant(false), myLocation: .constant(false), address: .constant("주소"), coordXXX: .constant(0.0), coordYYY: .constant(0.0),
        selectedPlacePosition: .constant(CLLocationCoordinate2D(latitude: 37.39570088983171, longitude: 127.1104335101161)))
}

extension String: Identifiable {
    public var id: String { self }
}
