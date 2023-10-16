//
//  FriendsLocationView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/25.
//

import SwiftUI

struct FriendsLocationView: View {
    var friendsLocationMapViewModel: FriendsLocationMapViewModel
    @State var isShowingFriendSheet: Bool = false
    @State private var travelTimesText = ""
    
    var body: some View {
        NavigationStack {
            FriendsLocationMapView()
            Spacer()
            Button {
                isShowingFriendSheet.toggle()
            } label: {
                Text("어디까지 왔나")
            }
            
        }
        .sheet(isPresented: $isShowingFriendSheet) {
            
            FriendsLocationListView(isShowingFriendSheet: .constant(false))
                .presentationDragIndicator(.visible)
        }
    }
}

#Preview {
    FriendsLocationView(friendsLocationMapViewModel: FriendsLocationMapViewModel())
}
