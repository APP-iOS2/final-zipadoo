//
//  AddFriendCellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/21.
//

import SwiftUI

struct AddFriendCellView: View {
    /// 약속에 참여할 친구배열
    @Binding var selectedFriends: [User]
    
    @State private var addFriendsSheet: Bool = false
    
    // 심볼이펙트
    @State private var animate = false
    
    var body: some View {
        VStack {
            HStack {
                Text("친구추가")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                Spacer()
                
                // 친구 추가버튼
                Image(systemName: "person.crop.circle.badge.plus")
                    .foregroundColor(.primary)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .symbolEffect(.bounce, value: animate)
                    .onTapGesture {
                        animate.toggle()
                        addFriendsSheet.toggle()
                    }
                
                
            }
            .padding(.top, 60)
            
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 0.5)
                .foregroundColor(.secondary)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                .frame(width: 360, height: 120)
                .overlay {
                    HStack {
                        VStack {
                            HStack {
                                /*
                                 VStack {
                                 HStack {
                                 if selectedFriends.isEmpty {
                                 Text("초대 할 친구를 추가해주세요.")
                                 } else { */
                                ScrollView(.horizontal) {
                                    HStack {
                                        ForEach(selectedFriends) { friend in
                                            FriendSellView(selectedFriends: $selectedFriends, friend: friend).padding()
                                                .padding(.trailing, -50)
                                        }
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                }
                                .frame(height: 90)
                                .scrollIndicators(.hidden)
                            }
                        }
                    }
                }
                .sheet(isPresented: $addFriendsSheet) {
                    FriendsListVIew(isShowingSheet: $addFriendsSheet, selectedFriends: $selectedFriends)
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    animate.toggle()
                    addFriendsSheet.toggle()
                }
        }
    }
}

#Preview {
    AddFriendCellView(selectedFriends: .constant([]))
}
