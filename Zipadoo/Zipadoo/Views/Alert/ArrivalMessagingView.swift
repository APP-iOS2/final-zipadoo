//
//  ArrivalMessagingView.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

enum ArrivalType: String {
    case early = "일찍"
    case late = "늦게"
    case onTime = "에 딱 맞춰"
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
                rank: 2,
                arrivarDifference: 720.3641,
                potato: 500)))

        }
    }
}

struct ArrivalMessagingView: View {
    /// 확인버튼누른 후 창 닫기
    @Binding var isPresented: Bool
    var arrival: ArrivalMsgModel
    
    var timeDifference: String {
        let timeDiff = abs(arrival.arrivarDifference)
        switch timeDiff {
        case 0:
            return ""
        case 0..<3600:
            let minute = timeDiff / 60
            return "보다 \(Int(minute))분 "
        case 3600..<86400:
            let hours = timeDiff / (60 * 60)
            let minute = Int(timeDiff) % (60 * 60) / 60
            var message = "보다 \(Int(hours))시간 "
            message += minute == 0 ? "" : "\(minute)분 "
            return message
        default:
            return ""
        }
    }
    
    var arrivalType: ArrivalType {
        if arrival.arrivarDifference > 0 {
            .early
        } else if arrival.arrivarDifference < 0 {
            .late
        } else {
            .onTime
        }
    }
    
    var isRanking: Bool {
        if arrival.rank < 4 {
            return true
        }
        return false
    }
    // MARK: - body
    var body: some View {
        ZStack {
            if let url = URL(string: "https://lottiefiles.com/animations/confetti-throw-9oxIpCIgx3") {
                VStack {
                    LottieView(url: url)
                    Spacer()
                }
            }
//            LottieView(filename: <#T##String#>)
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
        }
    }
    // MARK: - 도착정보
    var ArriveMessageView: some View {
        VStack {
            ProfileImageView(imageString: arrival.profileImgString, size: .regular)
                .padding(.vertical, 12)
            
            VStack {
                Text("\(arrival.name)님")
                
                Text("\(arrival.rank)등으로 도착하셨습니다!")
                    .fontWeight(.semibold)
                
            }
            .padding(.bottom, 3)
            
            Text("약속 시간\(timeDifference)\(arrivalType.rawValue) 오셨네요")
            
//                if arrivalType == .late {
                Text("다음부턴 조금 더 일찍 출발해보세요!")
                Text("\(arrival.potato)감자가 차감 될 예정입니다")
                    .font(.footnote).bold()
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
//                }
            
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
                .padding(EdgeInsets(top: 12, leading: 0, bottom: 18, trailing: 0))
                .frame(maxWidth: .infinity)
        }
    }
}

struct ArrivalMessagingModifier: ViewModifier {
    @Binding var isPresented: Bool
    var arrival: ArrivalMsgModel
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .blur(radius: 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.isPresented = false
                    }
                    
                ArrivalMessagingView(isPresented: $isPresented, arrival: arrival)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            
            }
        }
        .animation(
            isPresented
            ? .spring(response: 0.5)
            : .none,
            value: isPresented
        )
    }
}

#Preview {
//    Text("약속 장소 도착 Alert")
//      .modifier(
//        ArrivalMessagingModifier(isPresented: .constant(true), arrival: ArrivalMsgModel(
//            name: "아라",
//            profileImgString: "https://cdn.discordapp.com/emojis/1154686109234774058.webp?size=240&quality=lossless",
//            rank: 2,
//            arrivarDifference: 720.3641,
//            potato: 500))
//      )
    ExampleView()
}
