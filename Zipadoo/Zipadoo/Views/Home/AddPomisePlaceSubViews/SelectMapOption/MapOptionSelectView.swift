//
//  MapOptionSelectView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

//import SwiftUI
// MARK: - 상단탭바 뷰 모델, 사용하지 않음(옵션보여주기에 대해 이슈 발생시 예비용)
/// 상단탭바 뷰 모델
//struct MapOptionSelectView: View {
//    var mapOptions: MapOption
//    @Binding var isClickedPlace: Bool
//    @Binding var addLocationButton: Bool
//    /// 장소명 값
//    @Binding var destination: String
//    /// 주소 값
//    @Binding var address: String
//    
//    @Binding var promiseLocation: PromiseLocation
//    
//    var body: some View {
//        VStack {
//            switch mapOptions {
//            case .click:
//                MapView(destination: $destination, address: $address, isClickedPlace: $isClickedPlace, promiseLocation: $promiseLocation)
//            case .search:
//                NewMapView(destination: $destination, address: $address, isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, promiseLocation: $promiseLocation)
//            }
//        }
//    }
//}

//#Preview {
//    MapOptionSelectView(mapOptions: .click, isClickedPlace: .constant(false), addLocationButton: .constant(false), destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
//}
