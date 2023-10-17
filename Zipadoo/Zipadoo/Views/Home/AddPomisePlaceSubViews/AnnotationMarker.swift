//
//  AnnotationMarker.swift
//  Zipadoo
//
//  Created by 김상규 on 10/9/23.
//

import SwiftUI

/// PreviewPlaceOnMap 뷰에서 사용되는 Marker 뷰모델
struct AnnotationMarker: View {
    var body: some View {
        ZStack {
            Image(systemName: "circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .shadow(radius: 3)
                .foregroundStyle(.blue)
            
//            Image(systemName: "arrowtriangle.down.fill")
//                .resizable()
//                .scaledToFit()
//                .frame(width: 10, height: 25)
//                .offset(x: 0, y: 22)
//                .foregroundStyle(.blue)
            
            Image(systemName: "flag.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.yellow)
        }
        .offset(x: 0, y: -10)
    }
}

#Preview {
    AnnotationMarker()
}
