//
//  FriendsView.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/21.
//

import SwiftUI

struct FriendsView: View {
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(friends, id: \.self) { friend in
                    HStack {
                        Image(systemName: "person.fill")
                        Text(friend)
                    }
                }
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(friends, id: \.self ) { fri in
                        FriendsRequestCellView()
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                    )
                }
            }
            .navigationTitle("친구 목록")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        //                        FriendsRegistrationView()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
        }
    }
}

struct FriendsRequestCellView: View {
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        HStack {
            
            Image(systemName: "person.fill")
            
            VStack {
                Text("\(friends[0])님이 친구 요청을 보냈어요")
                
                HStack {
                    Button(action: {
                        
                    }, label: {
                        Text("거절")
                        
                    })
                    .foregroundColor(.red)
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1.5)
                    )
                    
                    Button(action: {
                        
                    }, label: {
                        Text("수락")
                    })
                    .padding(7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1.5)
                    )
                }
            }
        }
        .padding()
    }
}

#Preview {
    FriendsView()
    //        FriendsRequestCellView()
}
