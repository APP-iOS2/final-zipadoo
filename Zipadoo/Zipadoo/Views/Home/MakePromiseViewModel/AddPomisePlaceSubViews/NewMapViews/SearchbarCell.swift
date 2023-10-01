//
//  SearchbarCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit

struct SearchBarCell: View {
    @ObservedObject var searchOfKakaoLocal: SearchOfKakaoLocal = SearchOfKakaoLocal.sharedInstance
    @State private var searchText: String = ""
    @State var searching: Bool = false
//    @Binding var x: Double
//    @Binding var y: Double
    @Binding var isClickedPlace: Bool
    @Binding var placeName: String
//    @Binding var address: String
    @Binding var selectedPlacePosition: CLLocationCoordinate2D?
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        VStack {
            HStack {
                TextField("키워드를 입력하세요", text: $searchText)
                    .textFieldStyle(.roundedBorder)
                Button {
                    searching = true
                    searchOfKakaoLocal.searchKLPlace(keyword: searchText)
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
            
            if searching == true {
                List(searchOfKakaoLocal.searchKakaoLocalDatas, id: \.place_name) { result in
                    VStack {
                        Button {
                            if let xValue = Double(result.y), let yValue = Double(result.x) {
                                promiseLocation.latitude = xValue
                                promiseLocation.longitude = yValue
                                selectedPlacePosition = CLLocationCoordinate2D(latitude: promiseLocation.latitude, longitude: promiseLocation.longitude)
                            } else {
                                print("변환 실패")
                            }
                            
                            placeName = result.place_name
                            promiseLocation.address = result.road_address_name
                            print("장소 이름: \(placeName)")
                            print("주소: \(                            promiseLocation.address)")
                            print("장소 위도: \(promiseLocation.latitude)")
                            print("장소 경도: \(promiseLocation.longitude)")
                            
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
                                        .padding(.bottom,5)
                                        
                                        HStack {
                                            Text(result.road_address_name)
                                                .font(.subheadline)
                                                .foregroundColor(.black)
                                            Spacer()
                                        }
                                    }
                                    Spacer()
                                    
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "phone.circle.fill")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30)
                                    }
                                    .tint(.yellow)
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
    SearchBarCell(isClickedPlace: .constant(false), placeName: .constant("장소 이름"), selectedPlacePosition: .constant(CLLocationCoordinate2D(latitude: 37.39570088983171, longitude: 127.1104335101161)), promiseLocation: .constant( PromiseLocation(latitude: 0.0, longitude: 0.0, address: "서울시 강남구 압구정로 165")))
}
