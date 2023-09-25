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
        Rectangle().stroke(Color.gray, lineWidth: 0.5)
            .frame(width: 350, height: 130)
            .overlay {
                HStack {
                    VStack {
                        HStack {
                            Text("친구 추가")
                                .font(.title3)
                            Spacer()
                        }
                        .padding(.leading, 15)
                        .padding(.top)
                        
                        HStack {
                            ScrollView(.horizontal) {
                                HStack {
                                    ForEach(selectedFriends, id: \.self) { name in
                                        
                                        FriendSellView(name: name, selectedFriends: $selectedFriends).padding()
                                            .padding(.trailing, -50)
                                    }
                                }
                                .padding(.leading, -10)
                                .padding(.trailing, 50)
                                .padding(.bottom, 10)
                            }
                            .frame(height: 90)
                            .scrollIndicators(.hidden)
                        }
                        .padding(.leading, 0)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ZStack {
                            Color.accentColor
                                .frame(width: 70, height: 130)
                            Button {
                                addFriendsSheet.toggle()
                                print("친구 추가")
                            } label: {
                                Image(systemName: "plus.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                            }
                            .tint(.white)
                        }
                    }
                    .padding(.leading, -10)
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
