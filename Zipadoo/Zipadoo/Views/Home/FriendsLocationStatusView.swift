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
func convertPecentage(depature: Double, arrival: Double) -> String {
    let current: Double = arrival - depature
    let remainingDistance: Double = current/arrival
    return "\(Int(remainingDistance * 100))%"
}

import SwiftUI

struct FriendsLocationStatusView: View {
    @State private var value: Double = 0.4
    
//    let friends = ["홍길동", "둘리", "도우너", "도우너", "도우너", "도우너"]
    
    // 더미데이터
    let dummyFriends: [DummyFriendsLocation] = [
        // 피카츄 출발 위치 : 용인터미널 근처, 현재 위치 : 서울남부터미널
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        // 피카츄 출발 위치 : 경상북도청 근처, 현재 위치 : 서울남부터미널
        DummyFriendsLocation(name: "지우", depatureLocationLatitude: 36.57315945594544, depatureLocationLongitude: 128.50517666829037, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798),
        DummyFriendsLocation(name: "피카츄", depatureLocationLatitude: 37.237585941025316, depatureLocationLongitude: 127.21314261910263, currentLocationLatitude: 37.48465817016523, currentLocationLongitude: 127.01588584214798)
    ]
    
    @State var totalDistance: Double = 0
    @State var remainingDistance: Double = 0

    // 더미데이터 끝
    
    var body: some View {
        VStack {
            ForEach(dummyFriends) { friend in
                ProgressWithImageView(value: value, label: { Text(friend.name) }, currentValueLabel: { Text(convertPecentage(depature: friend.remainingDistance, arrival: friend.totalDistance)) })
                    .progressViewStyle(BarProgressStyle(height: 25))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))
                    .shadow(radius: 5)
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
        .padding()
    }
}

struct BarProgressStyle: ProgressViewStyle {
    var color: UIColor = #colorLiteral(red: 0.4964652658, green: 0.2767619491, blue: 0.01609945111, alpha: 1)
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        
        return GeometryReader { geometry in
            VStack(alignment: .leading) {
                configuration.label.font(labelFontStyle)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(uiColor: .systemGray3))
                        .frame(height: height)
                        .frame(width: geometry.size.width)
                    
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(color))
                        .frame(width: geometry.size.width * CGFloat(progress), height: height)
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
                        .offset(x: geometry.size.width * CGFloat(progress) - 25, y: 0)
                }
            }
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
