//
//  AddFriendCellView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/21.
//

import SwiftUI

struct AddFriendCellView: View {
    @State private var addFriendsSheet: Bool = false
    
    @State private var selectedFriends: [String] = []
    
    var body: some View {
        HStack {
            Text("친구추가")
                .font(.title2)
                .bold()
            
            Spacer()
            
            Button {
                addFriendsSheet.toggle()
                print("친구 추가")
            } label: {
                Label("추가하기", systemImage: "plus")
                    .foregroundColor(.black)
            }
            .buttonStyle(.bordered)
        }
        .padding(.top, 40)
        
        RoundedRectangle(cornerRadius: 5)
            .stroke(lineWidth: 0.5)
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
                                    ForEach(selectedFriends, id: \.self) { name in
                                        FriendSellView(name: name, selectedFriends: $selectedFriends).padding()
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
    }
}

#Preview {
    AddFriendCellView()
}
