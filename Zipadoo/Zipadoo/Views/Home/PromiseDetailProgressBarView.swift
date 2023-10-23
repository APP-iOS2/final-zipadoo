//
//  PromiseDetailProgressBarView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/21.
//

import SwiftUI
import CoreLocation
import MapKit

struct ProgressBarItem {
    let name: String
    var progress: Double
    let imageName: String
}

struct PromiseDetailProgressBarView: View {
    
    @ObservedObject var locationStore: LocationStore
    @Binding var region: MapCameraPosition
    let destinationCoordinate: CLLocationCoordinate2D
    var promise: Promise
    
    @Binding var progressTrigger: Bool
    @Binding var detents: PresentationDetent
    
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
                        Text(!progressTrigger ? "친구현황보기   " : "접기")
                    }
                })
            }
            // 나
                VStack(alignment: .leading) {
                    HStack {
                        Text(AuthStore.shared.currentUser?.nickName ?? "나")
                        Spacer()
                        let distance = calculateDistanceInMeters(x1: locationStore.myLocation.currentLatitude, y1: locationStore.myLocation.currentLongitude, x2: promise.latitude, y2: promise.longitude)
                        Text("남은 거리 : \(formatDistance(distance))  ")
                    }
                    .offset(y: 15)
                    
                    let ratio = caculateRatio(location: locationStore.myLocation)
                    
                    ZStack(alignment: .leading) {
                        RoundedRectangle(cornerRadius: 10) // Rounded rectangle design
                            .frame(height: 38)
                            .foregroundColor(Color.gray)
                        
                        RoundedRectangle(cornerRadius: 10)
                            .frame(width: CGFloat(ratio) * UIScreen.main.bounds.width, height: 38) // Set width to fill the view
                            .foregroundColor(Color.brown)
                        // 지도 위치 움직이기
                        Button {
                            
                        } label: {
                            Image(AuthStore.shared.currentUser?.moleDrillImageString ?? "doo1_1")
                                .resizable()
                                .frame(width: 38, height: 55.95)
                                .foregroundColor(.green)
                                .offset(y: 15)
                                .rotationEffect(.degrees(270))
                                .offset(x: CGFloat(ratio) * UIScreen.main.bounds.width - 20)
                        }
                }
            }
            // 친구들
            if progressTrigger {
                ForEach(locationStore.locationParticipantDatas.filter {
                    $0.location.participantId != AuthStore.shared.currentUser?.id ?? ""
                }) { friends in
                    VStack(alignment: .leading) {
                        HStack {
                            Text("\(friends.nickname)")
                            Spacer()
                            let distance = calculateDistanceInMeters(x1: friends.location.currentLatitude, y1: friends.location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
                            Text("남은 거리 : \(formatDistance(distance))  ")
                        }
                        .offset(y: 15)
                        // 남은 거리 비율
                        let ratio = caculateRatio(location: friends.location)
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10) // Rounded rectangle design
                                .frame(height: 38)
                                .foregroundColor(Color.gray)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: CGFloat(ratio) * UIScreen.main.bounds.width, height: 38)
                                .animation(.linear(duration: 2), value: ratio)// Set width to fill the view
                                .foregroundColor(Color.brown)
                            
                            // 지도 위치 움직이기
                            Button {
                                
                            } label: {
                                Image(friends.moleDrillImageString)
                                    .resizable()
                                    .frame(width: 38, height: 55.95)
                                    .foregroundColor(.green)
                                    .offset(y: 15)
                                    .rotationEffect(.degrees(270))
                                    .offset(x: CGFloat(ratio) * UIScreen.main.bounds.width - 20)
                            }
                        }
                    }
                    .onAppear {
                        withAnimation(.easeIn(duration: 2)) {
                            // 애니메이션을 위해서 강제로 넣었는데, 안전한 코드인지 모르겠음.
                            //                            progressMe[index] = progressBarsMe[index].progress
                            
                        }
                    }
                }
            }
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

struct PromiseDetailProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        PromiseDetailProgressBarView(locationStore: LocationStore(), region: .constant(.automatic), destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323), promise: Promise(id: "", makingUserID: "", promiseTitle: "사당역 모여라", promiseDate: 1697694660, destination: "왕십리 캐치카페", address: "서울특별시 관악구 청룡동", latitude: 37.47694972793077, longitude: 126.98195644152227, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10), progressTrigger: .constant(false), detents: .constant(.medium))
    }
}

extension PromiseDetailProgressBarView {
    /// %구하는 함수
    func distanceRatio(depature: Double, arrival: Double) -> Double {
        let current: Double = arrival - depature
        var remainingDistance: Double = current/arrival
        
        // 만약 remainingDistance가 0보다 작다면 그냥 0을 반환
        if remainingDistance < 0 {
            remainingDistance = 0
        }
        // 현재거리/총거리 비율
        return remainingDistance
        
        // return "\(Int(remainingDistance * 100))%"
    }
    
    /// 직선거리 계산 함수
    func straightDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
        let z: Double = sqrt(pow(x2-x1, 2) + pow(y2-y1, 2))
        return z
    }
    /// 최종적으로 비율을 계산해주는 함수
    func caculateRatio(location: Location) -> Double {
        let totalDistance = straightDistance(x1: location.departureLatitude, y1: location.departureLongitude, x2: promise.latitude, y2: promise.longitude)
        let remainingDistance = straightDistance(x1: location.currentLatitude, y1: location.currentLongitude, x2: promise.latitude, y2: promise.longitude)
        return distanceRatio(depature: totalDistance, arrival: remainingDistance)
    }
    /// 지구가 원이라,, 거리를 원주 기준으로? 맞나?
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    /// 현재 위치, 도착 위치 매개변수
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
    /// 미터로 변경
    func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}
