//
//  FriendsLocationMarkView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/01.
//

import SwiftUI

struct FriendsImageView: View {
    var friendImgString: String
    var colorRed: CGFloat = 0.74
    var colorGreen: CGFloat = 0.44
    var colorBlue: CGFloat = 0.44
    
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 60)
                .foregroundColor(Color(red: colorRed, green: colorGreen, blue: colorBlue))
            Image(friendImgString)
                .resizable()
                .scaledToFit()
                .frame(width: 50)
        }
    }
}

#Preview {
    FriendsImageView(friendImgString: "bear")
}
