//
//  FriendsMapSubView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/12.
//

import SwiftUI
import CoreLocation
import MapKit

extension PromiseTitleAndTime {
    func calculateTimeRemaining(targetTime: Double) -> String {
        let currentTime = Date().timeIntervalSince1970
        let timeDifference = targetTime - currentTime

        if timeDifference <= 0 {
            return "Time has expired"
        } else {
            let days = Int(timeDifference / 86400)
            let hours = Int((timeDifference.truncatingRemainder(dividingBy: 86400) / 3600))
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600) / 60))
            let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))

            if days > 0 {
                return String(format: "%d일 %02d시 %02d분 %02d초", days, hours, minutes, seconds)
            } else {
                return String(format: "%02d시 %02d분 %02d초", hours, minutes, seconds)
            }
        }
    }
}

struct FriendsMapSubView: View {
    @ObservedObject var locationStore: LocationStore
    @Binding var isShowingFriendSheet: Bool
    @Binding var region: MapCameraPosition
    let destinationCoordinate: CLLocationCoordinate2D
    var promise: Promise
    var body: some View {
        VStack {
            PromiseTitleAndTime(promise: promise)
            .padding(5)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(locationStore.locationParticipantDatas) { annotation in
                    if annotation.location.participantId == AuthStore.shared.currentUser?.id ?? "" {
                        Button {
                            region = .region(MKCoordinateRegion(center: locationStore.myLocation.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        } label: {
                            InfoView(name: annotation.nickname,
                                     imageString: AuthStore.shared.currentUser?.moleImageString ?? "",
                                     destinationLatitude: destinationCoordinate.latitude,
                                     destinationLongitude: destinationCoordinate.longitude,
                                     currentLatitude: locationStore.myLocation.currentLatitude,
                                     currentLongitude: locationStore.myLocation.currentLongitude)
                        }
                    } else {
                        Button {
                            region = .region(MKCoordinateRegion(center: annotation.location.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        } label: {
                            InfoView(name: annotation.nickname,
                                     imageString: annotation.moleImageString,
                                     destinationLatitude: destinationCoordinate.latitude,
                                     destinationLongitude: destinationCoordinate.longitude,
                                     currentLatitude: annotation.location.currentLatitude,
                                     currentLongitude: annotation.location.currentLongitude)
                        }
                    }
                }
            }
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingFriendSheet = false
                    } label: {
                        Image(systemName: "x.square")
                    }
                    
                }
            })
            
            Spacer()
        }
    }
}

#Preview {
    FriendsMapSubView(locationStore: LocationStore(), isShowingFriendSheet: .constant(true),
                      region: .constant(.automatic),
                      destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
                      promise: Promise(id: "", makingUserID: "", promiseTitle: "", promiseDate: 0, destination: "", address: "", latitude: 0, longitude: 0, participantIdArray: [], checkDoublePromise: true, locationIdArray: [], penalty: 0))
}

struct InfoView: View {
    let name: String
    let imageString: String
    let destinationLatitude: Double
    let destinationLongitude: Double
    let currentLatitude: Double
    let currentLongitude: Double
    @State private var distance: Double = 0
    var body: some View {
        VStack {
            Text(name)
                .font(.subheadline)
            Image(imageString)
                .resizable()
                .frame(width: 50, height: 50) // 크기 조절
                .aspectRatio(contentMode: .fill)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
            Text(formatDistance(distance))
        }
        .padding()
        .task {
            // 유저 위도 경도 가져와서 distance 만들어야함.
            distance = calculateDistanceInMeters(x1: currentLatitude, y1: currentLongitude, x2: destinationLatitude, y2: destinationLongitude)
            print("가져온 위도 : \(currentLatitude)")
            print("계산된 거리값 : \(distance)")
        }
    }
}

struct PromiseTitleAndTime: View {
    var promise: Promise
    @State private var RemainingTime: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        Group {
            Text("\(promise.promiseTitle)")
                .padding(.top)
                .bold()
            // 수정 필요
            Text("남은시간 : \(RemainingTime)")
                .font(.title3)
                .bold()
        }
        .task {
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .onReceive(timer) { _ in
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
    }
}

extension InfoView {
    // 재승 작성, 위도,경도로 미터 구하는 함수
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    // 현재 위치, 도착 위치 매개변수
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
    
    func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}
