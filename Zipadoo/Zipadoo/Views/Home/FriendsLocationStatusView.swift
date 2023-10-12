//
//  FriendsLocationStatus.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/22.
//

// 더미데이터 출발점 위도 경도, 현재위치 위도 경도, 도착지점 위도 경도
// 더미데이터 도착지 위도 경도
struct DummyFriendsLocation: Identifiable {
    var id: UUID = UUID()
    let name: String
    let depatureLocationLatitude: Double
    let depatureLocationLongitude: Double
    let currentLocationLatitude: Double
    let currentLocationLongitude: Double
    // 약속 도착지 더미 데이터
    let title: String = "서울특별시 종로구 종로3길 17"
    let arrivalLocationLatitude: Double = 37.57104762888161
    let arrivalLocationLongitude: Double = 126.97870482197153
    // 총 여정 직선 길이
    var totalDistance: Double {
        straightDistance(x1: depatureLocationLatitude, y1: depatureLocationLongitude, x2: arrivalLocationLatitude, y2: arrivalLocationLongitude)
    }
    // 현재 위치 기반 남은 직선 길이
    var remainingDistance: Double {
        straightDistance(x1: currentLocationLatitude, y1: currentLocationLongitude, x2: arrivalLocationLatitude, y2: arrivalLocationLongitude)
    }
}

// 직선거리 계산 함수
func straightDistance(x1: Double, y1: Double, x2: Double, y2: Double) -> Double {
    let z: Double = sqrt(pow(x2-x1, 2) + pow(y2-y1, 2))
    return z
}
// %구하는 함수
func distanceRatio(depature: Double, arrival: Double) -> Double {
    let current: Double = arrival - depature
    let remainingDistance: Double = current/arrival
    // 현재거리/총거리 비율
    return remainingDistance
    // return "\(Int(remainingDistance * 100))%"
}

import SwiftUI

struct FriendsLocationStatusView: View {
  
    @State private var value: Double = 0.4
  
    let friends = ["홍길동", "둘리", "도우너", "또치"]
  
    // 더미데이터, 일단 사용자만이라도 실제 데이터 넣기
    let dummyFriends: [DummyFriendsLocation] = [
        // 피카츄 출발 위치 : 용인터미널 근처, 현재 위치 : 서울남부터미널
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        // 피카츄 출발 위치 : 경상북도청 근처, 현재 위치 : 서울남부터미널
        DummyFriendsLocation(name: "지우", depatureLocationLatitude: 36.57315945594544, depatureLocationLongitude: 128.50517666829037, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        // 라이츄 출발 위치 : 용인터미널 근처, 현재 위치 : 종로역
        DummyFriendsLocation(name: "라이츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.57239836277199, currentLocationLongitude: 126.98995924830066),
        // 라이츄 출발 위치 : 용인터미널 근처, 현재 위치 : 수원역
        DummyFriendsLocation(name: "파이리", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.26570110412163, currentLocationLongitude: 127.00041713174578),
        // 라이츄 출발 위치 : 용인터미널 근처, 현재 위치 : 용인동백역
        DummyFriendsLocation(name: "꼬부기", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.2692161242139, currentLocationLongitude: 127.15245177994676),
        // 라이츄 출발 위치 : 용인터미널 근처, 현재 위치 : 기흥역
        DummyFriendsLocation(name: "버터풀", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.2748982309358, currentLocationLongitude: 127.11572865543589)
    ]
    
    var body: some View {
        VStack {
            ForEach(dummyFriends) { friend in
                ProgressWithImageView(value: distanceRatio(depature: friend.remainingDistance, arrival: friend.totalDistance), label: { Text(friend.name) }, currentValueLabel: { Text("\(Int(distanceRatio(depature: friend.remainingDistance, arrival: friend.totalDistance) * 100))%") })
                    .progressViewStyle(BarProgressStyle(height: 25))
                    .transition(.opacity)
                    .shadow(radius: 5)
                    .padding(.bottom, 60)
            }
            /* HStack {
                Button(action: {
                    if self.value >= 0.05 {
                        self.value -= 0.05
                    }
                }, label: {
                    Text("-")
                        .font(.title)
                })
                
                Button(action: {
                    if self.value <= 0.99 {
                        self.value += 0.05
                    }
                }, label: {
                    Text("+")
                        .font(.title)
                })
            } */
        }
    }
}

struct BarProgressStyle: ProgressViewStyle {
    var color: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        
        return GeometryReader { geometry in
            VStack(alignment: .leading, spacing: -5) {
                configuration.label.font(labelFontStyle)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(width: geometry.size.width - 30, height: height)
                    
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(color))
                        .frame(width: geometry.size.width * CGFloat(progress) - 30, height: height)
                        .overlay {
                            if let currentValueLabel = configuration.currentValueLabel {
                                currentValueLabel
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    Image("MoleImage")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .offset(x: geometry.size.width * CGFloat(progress) - 55, y: 0)
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 22)
        }
    }
}

struct ProgressWithImageView: View {
    var value: Double
    var label: () -> Text
    var currentValueLabel: () -> Text
    
    var body: some View {
        ProgressView(value: value, label: label, currentValueLabel: currentValueLabel)
    }
}

#Preview {
    FriendsLocationStatusView()
}
