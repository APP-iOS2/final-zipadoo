//
//  FriendInfoView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/04.
//

import SwiftUI

struct MyLocationAndInfoView: View {
    let name: String
    let imageName: String
    let distance: String
    var colorRed: CGFloat = 0.74
    var colorGreen: CGFloat = 0.44
    var colorBlue: CGFloat = 0.44
    
    var body: some View {
        VStack {
            Text("\(name)(나)")
                .bold()
            ZStack {
                Circle()
                    .frame(width: 60)
                    .foregroundColor(Color(red: colorRed, green: colorGreen, blue: colorBlue))
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            Text(distance)
        }
        .padding()
    }
}

#Preview {
    MyLocationAndInfoView(name: "정한두", imageName: "dragon", distance: "10 km")
}
