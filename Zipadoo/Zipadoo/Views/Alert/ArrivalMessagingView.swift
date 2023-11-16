//
//  ArrivalMessagingView.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

/// 특정모서리에만 cornerRadius
struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ExampleView: View {
    @State var isShowingAlert: Bool = false
    var body: some View {
        VStack {
            Button {
                
                isShowingAlert.toggle()
            } label: {
                Text("알람")
            }
            .modifier(ArrivalMessagingModifier(isPresented: $isShowingAlert, arrival: ArrivalMsgModel(
                name: "아라",
                profileImgString: "https://cdn.discordapp.com/emojis/1154686109234774058.webp?size=240&quality=lossless",
                rank: 6,
//                arrivarDifference: 720.3641,
//                arrivarDifference: -70,
                arrivarDifference: -70,
                potato: 500)))
        }
    }
}

struct ArrivalMessagingView: View {
    /// 확인버튼누른 후 창 닫기
    @Binding var isPresented: Bool
    var arrival: ArrivalMsgModel
    
    var timeDifference: String {
        var timeDiff = arrival.arrivarDifference
        // 딱 맞춰 도착
        if timeDiff <= 0 && timeDiff > -60 {
            return ""
        }
        // 늦거나 일찍 왔을 때
        if timeDiff < 0 {
            // 늦게 왔을 때
            timeDiff = abs(timeDiff)
            switch timeDiff {
            case 60..<3600 :
                let minute = timeDiff / 60
                return "보다 \(Int(minute))분 "
            case 3600..<86400 :
                let hours = timeDiff / (60 * 60)
                let minute = Int(timeDiff) % (60 * 60) / 60
                var message = "보다 \(Int(hours))시간 "
                message += minute == 0 ? "" : "\(minute)분 "
                return message
            default:
                return ""
            }
        } else {
            // 일찍 왔을 때(30분이 최대)
            switch abs(timeDiff) {
            case 1..<3600 :
                let minute = timeDiff / 60
                return "보다 \(Int(minute) + 1)분 "

            default :
                return ""
            }
        }
    }
    
    var arrivalType: ArrivalType {
        let timeDiff = arrival.arrivarDifference
        if timeDiff <= 0 && timeDiff > -60 {
            return .onTime
        } else if timeDiff < 0 {
            return .late
        } else {
            return .early
        }
    }
    /// 3등안에 들었는가
    var isRanking: Bool {
        if arrival.rank < 4 {
            return true
        }
        return false
    }
    /// 각 상황마다 로티 String
    var lottieString: String {
        if arrivalType == .early || arrivalType == .onTime {
            if isRanking == true {
                return "https://lottie.host/3f01e2c7-0fcb-4058-947d-5e37c82fa32d/otX7lxQgCe.json"
            } else {
                return "https://lottie.host/b4193263-4975-4053-9ff4-7cdbb24a1b92/wZLCje4iDp.json"
            }
        } else {
            return "https://lottie.host/362fcc4b-6324-456e-9efe-722038236a33/d3gpMUHAvJ.json"
        }
    }
//    @State private var countdown = 3
    // MARK: - body
    var body: some View {
        
        ZStack {
            
            VStack {
                
                ArriveMessageView
                    .padding(EdgeInsets(top: 18, leading: 12, bottom: 0, trailing: 12))
                
                ButtonView
                    .background(.gray.opacity(0.1))
                    .border(.black.opacity(0.2))
                    .cornerRadius(40, corners: .bottomLeft)
                    .cornerRadius(40, corners: .bottomRight)
                
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.brown.opacity(0.5))
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(.white)
                    )
                
            )
            .overlay(
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.black.opacity(0.5), lineWidth: 1)
            )
            .drawingGroup()
            .padding(.horizontal, 40)
            
            // 지각안했을때
            if arrivalType == .early || arrivalType == .onTime {
                // 3등안에 들면
                if isRanking {
                    if let url = URL(string: lottieString) {
                        VStack {
                            LottieView(url: url, size: 100)
                                .frame(width: 50, height: 50)

                        }
                        .padding(EdgeInsets(top: 0, leading: 120, bottom: 290, trailing: 120))
                        
                    }
                } else { // 3등안에는 안들었으면
                    if let url = URL(string: lottieString) {
                        VStack {
                            LottieView(url: url, size: 450)
                                .frame(width: 50, height: 50)
                            
                        }
                        .padding(EdgeInsets(top: 0, leading: 120, bottom: 550, trailing: 120))
                        
                    }
                }
            } else { // 지각했으면
                if let url = URL(string: lottieString) {
                    VStack {
                        LottieView(url: url, size: 100)
                            .frame(width: 50, height: 50)
                        
                    }
                    .padding(EdgeInsets(top: 0, leading: 120, bottom: 400, trailing: 120))
                }
                
            }
        }
        //        .onAppear {
        //            Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
        //                //                        if countdown > 0 {
        //                //                            countdown -= 1
        //                //                        } else {
        //                //                            // 카운트가 0에 도달하면 타이머 중지 또는 원하는 작업 수행
        //                //                            timer.invalidate()
        //                //                            // 여기에 원하는 작업 추가
        //                //                        }
        //                if countdown != 0 {
        //                    countdown -= 1
        //                }
        //            }
        //        }
        
    }
    
    // MARK: - 도착정보
    var ArriveMessageView: some View {
        VStack {
            ProfileImageView(imageString: arrival.profileImgString, size: .regular)
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 5, trailing: 0))
            
            VStack {
                Text("\(arrival.name)님")
                
                Text("\(arrival.rank)등으로 도착하셨습니다!")
                    .fontWeight(.semibold)
                    .font(.title3)
                
            }
            .padding(.bottom, 3)
            
            Text("약속 시간\(timeDifference)\(arrivalType.rawValue) 오셨네요")
            
                .padding(.bottom, 12)
            
            if arrivalType == .late {
                Text("\(arrival.potato)감자가 차감 될 예정입니다")
                    .font(.footnote).bold()
                        .foregroundColor(.secondary)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                }
            
        }
    }
    // MARK: - 확인 버튼
    var ButtonView: some View {
        Button {
            isPresented = false
            print("Button clicked: \(isPresented)")
        } label: {
            Text("확인")
                .bold()
                .padding(EdgeInsets(top: 14, leading: 0, bottom: 18, trailing: 0))
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    Text("약속 장소 도착 Alert")
      .modifier(
        ArrivalMessagingModifier(isPresented: .constant(true), arrival: ArrivalMsgModel(
            name: "아라",
            profileImgString: "https://cdn.discordapp.com/emojis/1154686109234774058.webp?size=240&quality=lossless",
            rank: 2,
            arrivarDifference: 720.3641,
            potato: 500))
      )
//    ExampleView()
}
