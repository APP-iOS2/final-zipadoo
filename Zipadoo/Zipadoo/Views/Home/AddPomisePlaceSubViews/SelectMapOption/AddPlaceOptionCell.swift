//
//  AddPlaceOptionCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

// MARK: - 상단탭바 뷰모델, 사용하지 않음(옵션보여주기에 대해 이슈 발생시 예비용)
/// 참고 : https://velog.io/@high_sky8320/SwiftUI-상단탭바-구현하기
//import SwiftUI
//
//enum MapOption: String, CaseIterable {
//    case click = "직접 설정"
//    case search = "장소 검색"
//}
//
// MARK: - 상단탭바 뷰모델, 사용하지 않음(옵션보여주기에 대해 이슈 발생시 예비용)
/// 상단탭바 뷰모델
/// 1) 직접 마커를 이동시켜 자세히 위치를 설정하는 옵션
/// 2) 검색기능을 활용한 옵션으로 장소설정 기능 옵션
//struct AddPlaceOptionCell: View {
//    @State private var selectMapOption: MapOption = .click /// 상단 탭바 초기설정값
//    @Namespace private var animation
//    
//    @Binding var isClickedPlace: Bool
//    @Binding var addLocationButton: Bool
//    @Binding var destination: String
//    @Binding var address: String
//    @Binding var promiseLocation: PromiseLocation
//    
//    var body: some View {
//        VStack {
//            animate()
//            MapOptionSelectView(mapOptions: selectMapOption, isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, promiseLocation: $promiseLocation)
////            Spacer()
//        }
//    }
//    
//    @ViewBuilder
//    private func animate() -> some View {
//        HStack {
//            ForEach(MapOption.allCases, id: \.self) { item in
//                VStack {
//                    Text(item.rawValue)
//                        .font(.title3)
//                        .frame(maxWidth: .infinity/4, minHeight: 40)
//                        .foregroundColor(selectMapOption == item ? .cyan : .gray)
//
//                    if selectMapOption == item {
//                        Capsule()
//                            .foregroundColor(.gray)
//                            .frame(height: 3)
//                            .matchedGeometryEffect(id: "info", in: animation)
//                    }
//                }
//                .onTapGesture {
//                    withAnimation(.easeInOut) {
//                        self.selectMapOption = item
//                    }
//                }
//            }
//        }
//    }
//}

//#Preview {
//    AddPlaceOptionCell(isClickedPlace: .constant(false), addLocationButton: .constant(false), destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), promiseLocation: .constant(PromiseLocation(destination: "서울시청", address: "서울시청", latitude: 37.5665, longitude: 126.9780)))
//}
