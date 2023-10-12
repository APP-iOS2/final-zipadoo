//
//  FriendsMapSubView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/12.
//

import SwiftUI
import CoreLocation
import MapKit

struct FriendsMapSubView: View {
    @Binding var isShowingFriendSheet: Bool
    @State var friendsAnnotation: [Location] = []
    @Binding var region: MapCameraPosition
    @Binding var myLocation: Location
    let destinationCoordinate: CLLocationCoordinate2D
    var promiseTitle: String = "용인오세용"
    var remaningPromiseTime: String = "2시간 30분"
    
    var body: some View {
        VStack {
            Group {
                Text("\(promiseTitle)")
                    .padding(.top)
                    .bold()
                Text("남은시간 : \(remaningPromiseTime)")
                    .font(.title3)
                    .bold()
            }
            .padding(5)
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                ForEach(friendsAnnotation) { annotation in
                    Button {
                        region = .region(MKCoordinateRegion(center: annotation.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                    } label: {
                        InfoView(name: annotation.participantId, imageName: "유저이미지", departureLatitude: destinationCoordinate.latitude, departureLongitude: destinationCoordinate.longitude, currentLatitude: annotation.currentLatitude, currentLongitude: annotation.currentLongitude)
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
        .task {
            friendsAnnotation.insert(myLocation, at: 0)
        }
    }
}

#Preview {
    FriendsMapSubView(isShowingFriendSheet: .constant(true), region: .constant(.automatic), myLocation: .constant(Location(participantId: "나임", departureLatitude: 37.547551, departureLongitude: 127.080315, currentLatitude: 37.547551, currentLongitude: 127.080315)), destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323))
}

struct InfoView: View {
    let name: String
    let imageName: String
    let departureLatitude: Double
    let departureLongitude: Double
    let currentLatitude: Double
    let currentLongitude: Double
    @State private var distance: Double = 0
//    let lineColor: UIColor
    let strokeColors: [UIColor] = [
        .red, .orange, .yellow, .green, .blue, .cyan, .purple, .brown, .black
    ]
    
    var body: some View {
        VStack {
            Text(name)
                .font(.subheadline)
            ZStack {
                Circle()
                    .frame(width: 60)
                    .foregroundColor(Color(strokeColors.randomElement() ?? .blue))
                Image(.bear)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
            }
            Text(formatDistance(distance))
        }
        .padding()
        .task {
            // 유저 위도 경도 가져와서 distance 만들어야함.
            distance = calculateDistanceInMeters(x1: departureLatitude, y1: departureLongitude, x2: currentLatitude, y2: currentLongitude)
            print("가져온 위도 : \(currentLatitude)")
            print("계산된 거리값 : \(distance)")
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
