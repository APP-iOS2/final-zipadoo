//
//  FriendSellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

/// 더미 유저
let dummyUser: User = User(id: "1", name: "gs", nickName: "닉네임", phoneNumber: "01", profileImageString: "22", friendsIdArray: ["12", "2"], friendsIdRequestArray: ["3"], moleImageString: "doo1")
/// 참여자 닉네임, 프로필 나열
struct FriendCellView: View {
    /// 참여자 User타입 배열
    @Binding var selectedFriends: [User]
    
    var body: some View {
        ForEach(selectedFriends.indices, id: \.self) { index in
            VStack {
                ZStack {
                    ProfileImageView(imageString: selectedFriends[index].profileImageString, size: .small)

                    Button {
                        print("친구 삭제")
                        deleteFriend(index)
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }
                    .offset(x: 23, y: -22)
                }
                //            .shadow(radius: 1)
                .tint(.red)
                
                Text(selectedFriends[index].nickName)
                    .font(.callout)
            }
            .frame(width: 85, height: 85)
        }
    }
    /// 마이너스 버튼으로 참여자 삭제
    func deleteFriend(_ index: Int) {
            selectedFriends.remove(at: index)
    }
}

#Preview {
    FriendCellView(selectedFriends: .constant([dummyUser]))
}
