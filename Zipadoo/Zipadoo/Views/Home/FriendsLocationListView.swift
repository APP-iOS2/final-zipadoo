//
//  FriendsLocationView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/25.
//

import SwiftUI
import MapKit

struct FriendsLocationListView: View {
    @Binding var isShowingFriendSheet: Bool
    @StateObject var viewModel = FriendsLocationMapViewModel()
    
    var body: some View {
        ZStack {
            MapViewContainer(viewModel: viewModel)
                .onAppear {
                    viewModel.addFriendPinsAndCalculateTravelTimes()
                }
            Rectangle()
                .foregroundColor(.white)
            
            VStack {
                Text("약속이름 : 모각코")
                Text("남은시간 : 30분")
                
                // 그리드 레이아웃을 사용하여 친구 정보 표시
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                    ForEach(viewModel.travelInfoDictionary.sorted { $0.value.isMe && !$1.value.isMe }, id: \.key) { key, value in
                        if value.isMe { // isMe 값에 따라 다른 View 표시
                            MyLocationAndInfoView(name: key, imageName: value.imageName, distance: value.distanceText, lineColor: value.lineColor)
                        } else {
                            FriendsLocationAndInfoView(name: key, imageName: value.imageName, distance: value.distanceText, lineColor: value.lineColor)
                        }
                    }
                }
            }
            .padding()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    FriendsLocationListView(isShowingFriendSheet: .constant(false))
}
