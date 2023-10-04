//
//  Testingg.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/10/03.
//

import SwiftUI

struct ExpectedTravelTimeMarkView: View {
    var friendName: String
    var expectedTravelTime: String
    
    var body: some View {
        VStack {
            Text(friendName)
            FriendsImageView(friendImgString: "bear")
            Text(expectedTravelTime)
        }
    }
}

#Preview {
    ExpectedTravelTimeMarkView(friendName: "정한두", expectedTravelTime: "10분")
}
