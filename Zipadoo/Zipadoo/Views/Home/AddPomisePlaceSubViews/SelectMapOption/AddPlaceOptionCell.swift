//
//  AddPlaceOptionCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

// MARK: - 상단탭바 뷰모델
/// 참고 : https://velog.io/@high_sky8320/SwiftUI-상단탭바-구현하기
import SwiftUI

enum MapOption: String, CaseIterable {
    case click = "직접 설정"
    case search = "검색하기"
}

// MARK: - 직접 마커를 이동시켜 자세히 위치를 설정하는 옵션 / 검색기능을 활용한 옵션으로 장소설정 기능 제공
struct AddPlaceOptionCell: View {
    @State private var selectMapOption: MapOption = .click
    @Namespace private var animation
    
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
        VStack {
            animate()
            MapOptionSelectView(mapOptions: selectMapOption, isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, promiseLocation: $promiseLocation)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(MapOption.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.title3)
                        .frame(maxWidth: .infinity/4, minHeight: 50)
                        .foregroundColor(selectMapOption == item ? .black : .gray)

                    if selectMapOption == item {
                        Capsule()
                            .foregroundColor(.black)
                            .frame(height: 3)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
                        
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectMapOption = item
                    }
                }
            }
        }
    }
}

#Preview {
    AddPlaceOptionCell(isClickedPlace: .constant(false), addLocationButton: .constant(false), promiseLocation: .constant(PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청")))
}
