//
//  ProgressSubView.swift
//  Zipadoo
//
//  Created by 장여훈 on 11/14/23.
//

import SwiftUI
import MapKit
/*
/// PromiseDetailProgressBarView에서 사용
struct ProgressSubView: View {
    let friends: LocationAndParticipant
    @Binding var isShowingFriendSheet: Bool
    @Binding var region: MapCameraPosition
    let realRatio: Double
    @State var ratio: Double = 0
    @Binding var progressTrigger: Bool
    @Binding var promiseFinishCheck: Bool
    
    // 바의 시작 위치를 결정하는 offsetX 계산
    var offsetX: Double {
        if ratio <= 0.3 {
            // 0.3 이하일 때는 바의 시작 위치를 바끝에
            return 14
        } else if 0.7 <= ratio && ratio < 1 {
            // 0.7 이상일 때는 바의 시작 위치를 더 안으로
            return 42
        } else {
            // 그 외의 경우는 기본값 28
            return 28
        }
    }
    
    var body: some View {
        // 지도 위치를 움직이는 버튼
        Button {
            region = .region(MKCoordinateRegion(center: friends.location.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
            isShowingFriendSheet = false
        } label: {
            ZStack(alignment: .leading) {
                // 전체 바의 배경
                RoundedRectangle(cornerRadius: 10)
                    .frame(height: 38)
                    .foregroundColor(Color.gray)
                
                // 진행 상태를 나타내는 바
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: CGFloat(ratio) * (UIScreen.main.bounds.width - 64), height: 38)
                    .foregroundColor(Color.brown)
                
                // 약속 종료 여부와 진행 상태에 따라 두더지 이미지 및 위치 결정
                if promiseFinishCheck && ratio >= 1 {
                    Image(AuthStore.shared.currentUser?.moleDrillImageString ?? "doo1_1")
                        .resizable()
                        .frame(width: 38, height: 55.95)
                        .foregroundColor(.green)
                        .offset(x: CGFloat(ratio) * (UIScreen.main.bounds.width - 64) - CGFloat(offsetX) + 5)
                } else {
                    Image(AuthStore.shared.currentUser?.moleDrillImageString ?? "doo1_1")
                        .resizable()
                        .frame(width: 38, height: 55.95)
                        .foregroundColor(.green)
                        .offset(y: 15)
                        .rotationEffect(.degrees(270))
                        .offset(x: CGFloat(ratio) * (UIScreen.main.bounds.width - 64) - CGFloat(offsetX))
                }
            }
        }
        .task {
            withAnimation(.easeIn) {
                ratio = realRatio
            }
        }
    }
}
*/
