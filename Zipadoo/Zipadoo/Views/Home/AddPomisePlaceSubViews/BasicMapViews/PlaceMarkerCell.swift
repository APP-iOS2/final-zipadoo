//
//  PlaceMarkerCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
// MARK: - 직접설정 맵뷰 장소 마커 UI
/// 직접설정 맵뷰에서 사용되는 UI
struct PlaceMarkerCell: View {
    
    var body: some View {
        ZStack {
            
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .shadow(radius: 10)
            
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 30)
                .offset(x: 0, y: 30)
            
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 23, height: 23)
                .foregroundStyle(.white)
        }
        .foregroundStyle(.red)
    }
}

#Preview {
    PlaceMarkerCell()
}
