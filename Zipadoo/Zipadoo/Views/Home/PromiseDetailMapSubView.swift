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
    // 위치 정보 관리를 위한 ObservedObject
    @ObservedObject var locationStore: LocationStore
    
    // 맵뷰의 카메라 위치를 제어하는 Binding
    @Binding var region: MapCameraPosition
    
    // 목적지 좌표
    let destinationCoordinate: CLLocationCoordinate2D
    
    // 약속 정보
    var promise: Promise
    
    // 친구 현황 시트를 보여주는 Binding
    @Binding var isShowingFriendSheet: Bool
    
    // 프로그레스 바 갱신을 제어하는 State 변수
    @State private var progressTrigger: Bool = false
    
    // 현재 표시되는 높이를 제어하는 Binding
    @Binding var detents: PresentationDetent
    
    var body: some View {
        VStack(alignment: .leading) {
            // 약속 정보 및 시간을 표시하는 뷰
            PromiseTitleAndTimeView(promise: promise)
            
            // 스크롤 가능한 뷰 내에 프로그레스 바를 표시하는 뷰
            ScrollView {
                PromiseDetailProgressBarView(locationStore: locationStore, isShowingFriendSheet: $isShowingFriendSheet, region: $region, destinationCoordinate: destinationCoordinate, promise: promise, progressTrigger: $progressTrigger, detents: $detents)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(content: {
            // 상단 툴바에 닫기 버튼 추가
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
            // 뷰가 사라질 때 프로그레스 바 갱신 및 높이 초기화
            progressTrigger = false
            detents = .medium
        }
    }
}

struct PromiseInfoView: View {
    // 친구 이름
    let name: String
    
    // 친구 이미지 경로
    let imageString: String
    
    // 목적지 위도 경도
    let destinationLatitude: Double
    let destinationLongitude: Double
    
    // 현재 위치 위도 경도
    let currentLatitude: Double
    let currentLongitude: Double
    
    // 거리를 표시할 상태 변수
    @State private var distance: Double = 0
    
    var body: some View {
        VStack {
            // 친구 이름 표시
            Text(name)
                .font(.subheadline)
            
            // 친구 이미지 표시
            Image(imageString)
                .resizable()
                .frame(width: 50, height: 50)
                .aspectRatio(contentMode: .fill)
                .overlay(
                    Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
            
            // 거리 정보 표시
            Text(formatDistance(distance))
        }
        .padding()
        .task {
            // 현재 위치와 목적지 사이의 거리 계산
            distance = calculateDistanceInMeters(x1: currentLatitude, y1: currentLongitude, x2: destinationLatitude, y2: destinationLongitude)
            print("현재 위치 위도 : \(currentLatitude)")
            print("계산된 거리값 : \(distance)")
        }
    }
}

struct PromiseTitleAndTimeView: View {
    
    // 약속 정보
    var promise: Promise
    
    // 타이머
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // 남은 시간을 표시할 상태 변수
    @State private var RemainingTime: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            // 약속 제목
            Text("\(promise.promiseTitle)")
                .font(.title)
                .padding(.top)
                .padding(.bottom)
                .bold()
            
            // 약속 장소 정보
            HStack {
                Image(systemName: "pin")
                Text("\(promise.destination)")
            }
            
            // 약속 일시 정보
            let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
            HStack {
                Image(systemName: "clock")
                Text("\(formatDate(date: datePromise))")
            }
            
            // 남은 시간 표시
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
            // 초기에 남은 시간 설정
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
        .onReceive(timer) { _ in
            // 1초마다 남은 시간 갱신
            RemainingTime = calculateTimeRemaining(targetTime: promise.promiseDate)
        }
    }
}

#Preview {
    PromiseDetailMapSubView(locationStore: LocationStore(), region: .constant(.automatic),
                            destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
                            promise: Promise(id: "", makingUserID: "", promiseTitle: "사당역 모여라", promiseDate: 1697694660, destination: "왕십리 캐치카페", address: "서울특별시 관악구 청룡동", latitude: 37.47694972793077, longitude: 126.98195644152227, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
                            isShowingFriendSheet: .constant(true), detents: .constant(.medium))
}

extension PromiseInfoView {
    /// 각도를 라디안으로 변환하는 함수
    ///
    /// - Parameters:
    ///   - degrees: 변환할 각도
    /// - Returns: 라디안으로 변환된 값
    func degreesToRadians(_ degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }

    /// 두 지점 간의 거리를 미터로 계산하는 함수
    ///
    /// - Parameters:
    ///   - x1: 첫 번째 지점의 위도
    ///   - y1: 첫 번째 지점의 경도
    ///   - x2: 두 번째 지점의 위도
    ///   - y2: 두 번째 지점의 경도
    /// - Returns: 계산된 거리 (미터)
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

    /// 거리를 포맷팅하여 문자열로 반환하는 함수
    ///
    /// - Parameters:
    ///   - distance: 거리 (미터)
    /// - Returns: 포맷팅된 거리 문자열
    func formatDistance(_ distance: CLLocationDistance) -> String {
        if distance < 1000 {
            // 거리가 1,000미터 미만인 경우
            return String(format: "%.0f m", distance)
        } else {
            // 거리가 1,000미터 이상인 경우
            let distanceInKilometers = distance / 1000.0
            return String(format: "%.2f km", distanceInKilometers)
        }
    }
}

extension PromiseTitleAndTimeView {
    /// 남은 시간을 계산하여 문자열로 반환하는 함수
    ///
    /// - Parameters:
    ///   - targetTime: 목표 시간 (Unix Timestamp)
    /// - Returns: 계산된 시간 문자열
    func calculateTimeRemaining(targetTime: Double) -> String {
        // 현재 시간
        let currentTime = Date().timeIntervalSince1970
        // 목표 시간과의 차이
        let timeDifference = targetTime - currentTime
        
        // 시간이 이미 지났을 경우
        if timeDifference <= 0 {
            return "Time has expired"
        } else {
            // 남은 일, 시, 분, 초 계산
            let days = Int(timeDifference / 86400)
            let hours = Int((timeDifference.truncatingRemainder(dividingBy: 86400) / 3600))
            let minutes = Int((timeDifference.truncatingRemainder(dividingBy: 3600) / 60))
            let seconds = Int(timeDifference.truncatingRemainder(dividingBy: 60))
            
            // 남은 일수가 있을 경우
            if days > 0 {
                return String(format: "%d일 %02d시 %02d분 %02d초", days, hours, minutes, seconds)
            } else {
                // 일수가 없는 경우
                return String(format: "%02d시 %02d분 %02d초", hours, minutes, seconds)
            }
        }
    }
}

