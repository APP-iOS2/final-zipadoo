//
//  FriendsLocationMarkView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/01.
//

import SwiftUI

struct PlaceMarkView: View {
    var colorRed: CGFloat = 0.74
    var colorGreen: CGFloat = 0.44
    var colorBlue: CGFloat = 0.44
    
    var body: some View {
        VStack {
            FriendsImageView(friendImgString: "bear")
            
            Image(systemName: "arrowtriangle.down.fill")
                .font(.caption)
                .foregroundColor(Color(red: colorRed, green: colorGreen, blue: colorBlue))
                .offset(x: 0, y: -5)
        }
    }
}

#Preview {
    PlaceMarkView()
}
