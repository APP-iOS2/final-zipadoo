//
//  AnnotationCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI

// MARK: - 검색 설정 맵뷰 장소 마커 UI
/// 검색 설정 맵뷰에서 쓰이는 장소 마커 UI
struct AnnotationCell: View {
    var body: some View {
        ZStack {
            Image(systemName: "record.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.white, .red)
                .shadow(radius: 10)
            
            Image(systemName: "arrowtriangle.down.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 10, height: 25)
                .offset(x: 0, y: 16)
                .foregroundStyle(.red)
        }
    }
}

#Preview {
    AnnotationCell()
}
