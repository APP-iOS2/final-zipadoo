//
//  FriendSellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

/// 더미 유저
let dummyUser: User = User(id: "1", name: "gs", nickName: "닉네임", phoneNumber: "01", profileImageString: "22", friendsIdArray: ["12", "2"], friendsIdRequestArray: ["3"], moleImageString: "doo1")

struct FriendSellView: View {
    
    @Binding var selectedFriends: [User]
    
    var friend: User
    
    func deleteFriend(_ item: User) {
        if let index = selectedFriends.firstIndex(of: item) {
            selectedFriends.remove(at: index)
        }
    }
    
    var body: some View {
        VStack {
            ZStack {
                ProfileImageView(imageString: friend.profileImageString, size: .small)
                Button {
                    deleteFriend(friend)
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20)
                }
                .offset(x: 23, y: -22)
            }
            .tint(.red)
            
            Text(friend.nickName)
                .font(.callout)
        }
        .frame(width: 85, height: 85)
    }
}

// 뷰 따로 구성 필요
struct EditFriendSellView: View {
    @Binding var selectedFriends: [User]
    
    var friend: User
    
    var body: some View {
        VStack {
            ZStack {
                ProfileImageView(imageString: friend.profileImageString, size: .small)
            }
            
            Text(friend.nickName)
                .font(.callout)
        }
        .frame(width: 85, height: 85)
        //        }
    }
    func deleteFriend(_ item: User) {
        if let index = selectedFriends.firstIndex(of: item) {
            selectedFriends.remove(at: index)
        }
    }
}

#Preview {
    FriendSellView(selectedFriends: .constant([dummyUser]), friend: dummyUser)
}
