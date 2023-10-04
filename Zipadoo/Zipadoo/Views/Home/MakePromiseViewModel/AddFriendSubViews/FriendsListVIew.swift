//
//  FriendsListVIew.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/25.
//

import SwiftUI

struct FriendsListVIew: View {
    @Binding var isShowingSheet: Bool
    @Binding var selectedFriends: [String]
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        NavigationStack {
            List(friends, id: \.self) { friend in
                HStack {
                    Image(systemName: "person.fill")
                    Text(friend)
                        .onTapGesture {
                            selectedFriends.append(friend)
                            print(friend)
                            isShowingSheet = false
                            
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("친구 목록")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") {
                        isShowingSheet = false
                    }
                }
            }
        }
    }
}

#Preview {
    FriendsListVIew(isShowingSheet: .constant(true), selectedFriends: .constant([""]))
}
