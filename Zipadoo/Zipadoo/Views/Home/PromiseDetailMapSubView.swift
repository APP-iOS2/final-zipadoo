//
//  PromiseDetailMapSubView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/12.
//

import SwiftUI
import CoreLocation
import MapKit

struct PromiseDetailMapSubView: View {
    @ObservedObject var locationStore: LocationStore
    @Binding var region: MapCameraPosition
    let destinationCoordinate: CLLocationCoordinate2D
    var promise: Promise
    
    @Binding var isShowingFriendSheet: Bool
    @State private var progressTrigger: Bool = false
    @Binding var detents: PresentationDetent
    
    var body: some View {
        VStack(alignment: .leading) {
            PromiseTitleAndTimeView(promise: promise)
            ScrollView {
                PromiseDetailProgressBarView(locationStore: locationStore, isShowingFriendSheet: $isShowingFriendSheet, region: $region, destinationCoordinate: destinationCoordinate, promise: promise, progressTrigger: $progressTrigger, detents: $detents)
            }
            .scrollIndicators(.hidden)
        }
        // 왜 안먹지?
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingFriendSheet = false
                } label: {
                    Image(systemName: "x.square")
                }
                
            }
        })
        .padding()
        .onDisappear {
            progressTrigger = false
            detents = .medium
        }
    }
}

#Preview {
    PromiseDetailMapSubView(locationStore: LocationStore(), region: .constant(.automatic),
                            destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
                            promise: Promise(id: "", makingUserID: "", promiseTitle: "사당역 모여라", promiseDate: 1697694660, destination: "왕십리 캐치카페", address: "서울특별시 관악구 청룡동", latitude: 37.47694972793077, longitude: 126.98195644152227, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
                            isShowingFriendSheet: .constant(true), detents: .constant(.medium))
}

struct PromiseInfoView: View {
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

struct PromiseTitleAndTimeView: View {
    var promise: Promise
    @State private var RemainingTime: String = ""
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var body: some View {
        VStack(alignment: .leading) {
                Text("\(promise.promiseTitle)")
                    .font(.title)
                    .padding(.top)
                    .padding(.bottom)
                    .bold()
            HStack {
                Image(systemName: "pin")
                Text("\(promise.destination)")
            }
            /// 저장된 promiseDate값을 Date 타입으로 변환
            let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
            HStack {
                Image(systemName: "clock")
                Text("\(formatDate(date: datePromise))")
            }
            Text("남은시간 : \(RemainingTime)")
                .font(.title3)
                .bold()
                .foregroundStyle(.white)
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.bottom)
        }
        .padding(.leading)
        .padding(.trailing)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.primary)
                .opacity(0.05)
                .shadow(color: .primary, radius: 10, x: 5, y: 5)
            
        )
        .task {
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .onReceive(timer) { _ in
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
    }
}

extension PromiseInfoView {
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

extension PromiseTitleAndTimeView {
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
