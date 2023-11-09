//
//  PromiseDetailProgressBarView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct PromiseDetailProgressBarView: View {
    
    // 관찰 대상 객체로 사용되는 위치 정보 스토어
    @ObservedObject var locationStore: LocationStore
    
    // 친구 현황 시트 표시 여부를 결정하는 바인딩 변수
    @Binding var isShowingFriendSheet: Bool
    
    // 맵 뷰의 카메라 위치를 조절하는 바인딩 변수
    @Binding var region: MapCameraPosition
    
    // 목적지 좌표
    let destinationCoordinate: CLLocationCoordinate2D
    
    // 현재 약속 정보
    var promise: Promise
    
    // 약속 진행 상황을 감지하여 UI 갱신하는 바인딩 변수
    @Binding var progressTrigger: Bool
    
    // 약속 현황 시트의 높이를 제어하기 위한 바인딩 변수
    @Binding var detents: PresentationDetent
    
    // 1초마다 갱신되는 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 약속 종료 여부를 감지하는 상태 변수
    @State private var promiseFinishCheck: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
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
        }
        .task {
            promiseFinishCheck = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .onReceive(timer) { _ in
            promiseFinishCheck = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .padding(.leading)
        .padding(.trailing)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.primary)
                .opacity(0.05)
                .shadow(color: .primary, radius: 10, x: 5, y: 5)
            
        )
    }
}

extension PromiseDetailProgressBarView {
    /// 현재 거리 비율을 계산하여 반환하는 함수
    func distanceRatio(depature: Double, arrival: Double) -> Double {
        let current: Double = arrival - depature
        var remainingDistance: Double = current / arrival
        
        // 만약 remainingDistance가 0보다 작다면 그냥 0을 반환
        if remainingDistance < 0 {
            remainingDistance = 0
        }
        // 현재거리/총거리 비율
        return remainingDistance
    }
    
    /// 두 지점 간의 직선 거리를 계산하는 함수
    func straightDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        let z: Double = sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2))
        return z
    }
    
    /// 현재 위치와 목적지 간의 비율을 계산하는 함수
    func calculateRatio(location: Location) -> Double {
        let totalDistance = straightDistance(x1: location.departureLatitude, y1: location.departureLongitude, x2: promise.latitude, y2: promise.longitude)
        let remainingDistance = straightDistance(x1: location.currentLatitude, y1: location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
        return distanceRatio(depature: remainingDistance, arrival: totalDistance)
    }
    
    /// 지구가 원이라고 가정할 때, 각도를 라디안으로 변환하는 함수
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    
    /// 두 지점 간의 거리를 미터로 계산하는 함수
    func calculateDistanceInMeters(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        let earthRadius = 6371000.0 // 지구의 반경 (미터)
        
        let lat1 = degreesToRadians(x1)
        let lon1 = degreesToRadians(y1)
        let lat2 = degreesToRadians(x2)
        let lon2 = degreesToRadians(y2)
        
        let dLat = lat2 - lat1
        let dLon = lon2 - lon1
        
        let a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2)
        let c = 2 * atan2(sqrt(a), sqrt(1-a))
        
        let distance = earthRadius * c
        return distance
    }
    
    /// 미터 단위의 거리를 형식화하여 문자열로 반환하는 함수
    func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}

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

extension PromiseDetailProgressBarView {
    // 약속 종료 여부를 확인하는 함수
    func calculateTimeRemaining(targetTime: Double) -> Bool {
        // 현재 시간을 가져오기
        let currentTime = Date().timeIntervalSince1970
        // 목표 시간과 현재 시간의 차이 계산
        let timeDifference = targetTime - currentTime
        
        // 시간이 지났는지 여부를 반환
        if timeDifference <= 0 {
            // 약속 시간이 이미 지났음
            return true
        } else {
            // 아직 약속 시간이 남아있음
            return false
        }
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
