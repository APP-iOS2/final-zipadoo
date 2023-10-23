//
//  FriendsLocationStatus.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/22.
//

import SwiftUI

struct FriendsLocationStatusView: View {
    
    var promise: Promise
    @StateObject var locationStore: LocationStore = LocationStore()
    
    @State private var value: Double = 0.4
    
    var body: some View {
        VStack {
            ForEach(locationStore.locationParticipantDatas.filter {
                $0.location.participantId != AuthStore.shared.currentUser?.id ?? ""
            }) { friends in
                HStack(alignment: .bottom) {
                    let ratio = caculateRatio(location: friends.location)
                    // 두더지 이미지 드릴이미지로 치환
                    var moleImageString: String {
                        return friends.moleImageString + "_1"
                    }
                    // 지파두 위치뷰
                    // 만약 ratio가 0보다 작으면 0으로 해줘야함
                    ProgressWithImageView(value: ratio,
                                          label: { Text(friends.nickname) },
                                          currentValueLabel: { Text("")})
                    .progressViewStyle(BarProgressStyle(height: 25, imageString: moleImageString))
                    .transition(.opacity)
                    .padding(.bottom, 50)
                    
                    Text("\(Int(round(ratio * 100)))%")
                        .font(.title)
                        .bold()
                        .padding(3)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(radius: 0.8)
                        .padding(.trailing, 10)
                }
                
            }
        }
        .onAppear {
            Task {
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
            }
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

struct BarProgressStyle: ProgressViewStyle {
    var color: UIColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
    var height: Double = 20.0
    var labelFontStyle: Font = .body
    var imageString: String
    func makeBody(configuration: Configuration) -> some View {
        let progress = configuration.fractionCompleted ?? 0.0
        
        return GeometryReader { geometry in
            VStack(alignment: .leading, spacing: -5) {
                configuration.label.font(labelFontStyle)
                    .bold()
                    .padding(3)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .shadow(radius: 0.8)
                
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(uiColor: .systemBrown))
                        .stroke(Color.white, lineWidth: 3)
                        .frame(width: geometry.size.width - 40, height: height)
                        .shadow(radius: 0.8)
                    
                    RoundedRectangle(cornerRadius: 10.0)
                        .fill(Color(color))
                        .frame(width: (geometry.size.width - 40) * CGFloat(progress), height: height)
                        .overlay {
                            if let currentValueLabel = configuration.currentValueLabel {
                                currentValueLabel
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    // 유저 두더지 이미지로 변경
                    Image(imageString)
                        .resizable()
                        .frame(width: 50, height: 73.62)
                        .offset(x: (geometry.size.width - 30) * CGFloat(progress) - (geometry.size.width - 30) * CGFloat(progress) * 0.5, y: -30)
                        .rotationEffect(.degrees(270))
                        .offset(x: 33)

                    //                    geometry.size.width * CGFloat(progress)
                }
            }
            .padding(.leading, 8)
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
    FriendsLocationStatusView(promise:
                                Promise(
                                    id: "",
                                    makingUserID: "3",
                                    promiseTitle: "지각파는 두더지 모각코",
                                    promiseDate: 1697101051.302136,
                                    destination: "서울특별시 종로구 종로3길 17",
                                    address: "",
                                    latitude: 0.0,
                                    longitude: 0.0,
                                    participantIdArray: ["Bfgtj43NqldJHuDayAx8IsluMkH2", "k6VioFa0mfTc1oRIUzMs9dzjHVf1", "ZYmIOhjX36ZU1TAP87Vpzudeoj62"],
                                    checkDoublePromise: false,
                                    locationIdArray: ["00CDB834-2213-494E-B278-07F639881953", "03E48C4C-35FF-4D81-848F-D2430C6D3329", "04F7F43B-6A5B-45E2-8597-4C2C1E1D93EE"],
                                    penalty: 10))
}

extension FriendsLocationStatusView {
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
}
