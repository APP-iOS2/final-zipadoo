//
//  FriendInfoView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/04.
//

import SwiftUI

struct FriendsLocationAndInfoView: View {
    let name: String
    let imageName: String
    let distance: String
    let lineColor: UIColor // lineColor 추가
    
    var body: some View {
        VStack {
            Text(name)
            ZStack {
                Circle()
                    .frame(width: 60)
                    .foregroundColor(Color(lineColor))
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
    FriendsLocationAndInfoView(name: "정한두", imageName: "dragon", distance: "10 km", lineColor: .red)
}
