//
//  PromiseDetailProgressBarView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/21.
//

import SwiftUI
import CoreLocation
import MapKit

/// PromiseDetailMapSubView에서 사용
struct PromiseDetailProgressBarView: View {
    
    // 관찰 대상 객체로 사용되는 위치 정보 스토어
    @ObservedObject var locationStore: LocationStore
    
    /// 친구 현황 시트 표시 여부를 결정하는 바인딩 변수
    @Binding var isShowingFriendSheet: Bool
    
    /// 맵 뷰의 카메라 위치를 조절하는 바인딩 변수
    @Binding var region: MapCameraPosition
    
    /// 목적지 좌표
    let destinationCoordinate: CLLocationCoordinate2D
    
    /// 현재 약속 정보
    var promise: Promise
    
    /// 약속 진행 상황을 감지하여 UI 갱신하는 바인딩 변수
    @Binding var progressTrigger: Bool
    
    /// 약속 현황 시트의 높이를 제어하기 위한 바인딩 변수
    @Binding var detents: PresentationDetent
    
    /// 1초마다 갱신되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    /// 약속 종료 여부를 감지하는 상태 변수
    @State private var promiseFinishCheck: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            /*
            HStack {
                Text("두더지 친구들 현황")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                Spacer()
                Button(action: {
                    progressTrigger.toggle()
                    detents = progressTrigger ? .large : .medium
                }, label: {
                    HStack {
                        Image(systemName: !progressTrigger ? "chevron.down" : "chevron.up")
                        Text(!progressTrigger ? "전체현황보기   " : "접기")
                    }
                })
            }
            /// 나 디테일
            VStack(alignment: .leading) {
                
                /// 남은거리 / 전체거리 비율
                let ratio: Double = calculateRatio(location: locationStore.myLocation)
                /// ratio에 맞춰서 이미지 위치 조정 다르게 변경
                var offsetX: Double {
                    if ratio <= 0.3 {
                        // 0.3보다 작거나 같을때는 바끝에
                        return 14
                    } else if 0.7 <= ratio && ratio < 1 {
                        // 0.7보다 크거나 같을때는 더 들어가야함
                        return 42
                    } else {
                        // 기본값 28
                        return 28
                    }
                }
                
                HStack {
                    Text(AuthStore.shared.currentUser?.nickName ?? "나")
                    Spacer()
                    let distance = calculateDistanceInMeters(x1: locationStore.myLocation.currentLatitude, y1: locationStore.myLocation.currentLongitude, x2: promise.latitude, y2: promise.longitude)
                    // 지각 도착 메시지 분기문 처리
                    if promiseFinishCheck && ratio < 0.95 {
                        Text("아이쿠 지각입니당! ")
                    } else if promiseFinishCheck && ratio >= 1 {
                        Text("예쓰! 도착! ")
                    } else {
                        Text("남은 거리 : \(formatDistance(distance))  ")
                    }
                }
                .offset(y: 15)
                // 지도 위치 움직이기
                Button {
                    region = .region(MKCoordinateRegion(center: locationStore.myLocation.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                    isShowingFriendSheet = false
                } label: {
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10)
                            .frame(height: 38)
                            .foregroundColor(Color.gray)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: CGFloat(ratio) * (UIScreen.main.bounds.width - 64), height: 38)
                            .foregroundColor(Color.brown)
                        // 두더지 이미지 도착 분기처리
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
            }
            /// 친구들 디테일
            if progressTrigger {
                ForEach(locationStore.locationParticipantDatas.filter {
                    $0.location.participantId != AuthStore.shared.currentUser?.id ?? ""
                }) { friends in
                    VStack(alignment: .leading) {
                        let ratio = calculateRatio(location: friends.location)
                        /// ratio에 맞춰서 이미지 위치 조정 다르게 변경
                        HStack {
                            Text("\(friends.nickname)")
                            Spacer()
                            let distance = calculateDistanceInMeters(x1: friends.location.currentLatitude, y1: friends.location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
                            // 지각 도착 메시지 분기문 처리
                            if promiseFinishCheck && ratio < 0.95 {
                                Text("아이쿠 지각입니당!")
                            } else if promiseFinishCheck && ratio >= 1 {
                                Text("예쓰! 도착!")
                            } else {
                                Text("남은 거리 : \(formatDistance(distance))  ")
                            }
                        }
                        .offset(y: 15)
                        
                        ProgressSubView(friends: friends, isShowingFriendSheet: $isShowingFriendSheet, region: $region, realRatio: ratio, progressTrigger: $progressTrigger, promiseFinishCheck: $promiseFinishCheck)
                    }
                }
            }
            */
            
            // 두더지ProgressBar 주석 -> 남은거리만 보여주기
            HStack {
                Text("두더지 친구들의 남은 거리")
                    .bold()
                            
                Spacer()
            }
            .padding([.top, .leading, .trailing])
            
            Divider()
            
            // MARK: - 약속 친구 리스트 테스트
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(locationStore.locationParticipantDatas.filter {$0.location.participantId != AuthStore.shared.currentUser?.id}) { friend in
                    // 이미지 클릭시 현재 위치로 이동
                    Button {
                        region = .region(MKCoordinateRegion(center: locationStore.myLocation.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        isShowingFriendSheet = false
                    } label: {
                        VStack {

                            Image(friend.moleImageString)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 65)
                            
                            Text(friend.nickname)
                                .fontWeight(.medium)
                            
                            // 현재위치 정보가 있으면
                            if friend.location.currentLatitude > 0 && friend.location.currentLongitude > 0 {
 
                                if friend.location.rank > 0 {
                                    Text(promiseFinishCheck ? "지각" : "도착")
                                } else {
                                    // 남은 거리
                                    let distance = calculateDistanceInMeters(x1: friend.location.currentLatitude, y1: friend.location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
                                    Text("\(formatDistance(distance))")
                                }
                            } else {
                                Text("정보없음")
                            }
                        }
                        .foregroundColor(.primary)
                        .padding(.bottom)
                        .font(.footnote)
                    }
                }
            }
            .padding(.vertical)
        }
        .task {
            promiseFinishCheck = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        /// 매 초마다 약속이 종료되었는지 여부를 확인
        .onReceive(timer) { _ in
            promiseFinishCheck = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.primary)
                .opacity(0.05)
                .shadow(color: .primary, radius: 10, x: 5, y: 5)
        )
    }
}

struct PromiseDetailProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        PromiseDetailProgressBarView(
            locationStore: LocationStore(),
            isShowingFriendSheet: .constant(true),
            region: .constant(.automatic),
            destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
            promise: Promise(
                id: "",
                makingUserID: "",
                promiseTitle: "사당역 모여라",
                promiseDate: 1697694660,
                destination: "왕십리 캐치카페",
                address: "서울특별시 관악구 청룡동",
                latitude: 37.47694972793077,
                longitude: 126.98195644152227,
                participantIdArray: [],
                checkDoublePromise: false,
                locationIdArray: [],
                penalty: 10
            ),
            progressTrigger: .constant(false),
            detents: .constant(.medium)
        )
    }
}
