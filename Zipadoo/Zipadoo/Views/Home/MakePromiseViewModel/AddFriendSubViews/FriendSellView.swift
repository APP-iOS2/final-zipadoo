//
//  FriendSellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

struct FriendSellView: View {
    var name: String
    @Binding var selectedFriends: [String]
    
    var body: some View {
        ForEach(selectedFriends.indices, id: \.self) { index in
            VStack {
                ZStack {
                    Circle().stroke(Color.gray)
                    //                    .frame(width: 75, height: 60)
                    Button {
                        print("친구 삭제")
                        selectedFriends.remove(at: index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25)
                    }
                    .offset(x: 25, y: -24)
                }
                .shadow(radius: 1)
                .tint(.red)
                
                Text("\(name)")
                    .font(.callout)
            }
            .frame(width: 85, height: 85)
        }
    }
}

#Preview {
    FriendSellView(name: "해수", selectedFriends: .constant(["장여훈"]))
}
