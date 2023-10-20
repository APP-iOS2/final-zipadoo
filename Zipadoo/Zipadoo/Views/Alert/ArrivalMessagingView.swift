//
//  ArrivalMessagingView.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

struct ArrivalMessagingView: View {
    
    /// Alert 메세지 닫는 Bool 값
    @Binding var isPresented: Bool
    
    /// ArrivalMsModel 모델 생성
    var arrival: ArrivalMsgModel
    
    /// 도착 시간과 비교
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
    
    /// Enum 선언된 ArrivalType
    var arrivalType: ArrivalType {
        if arrival.arrivarDifference > 0 {
            .early
        } else if arrival.arrivarDifference < 0 {
            .late
        } else {
            .onTime
        }
    }
    
    var body: some View {
        VStack {
            ProfileImageView(imageString: arrival.profileImgString, size: .regular)
                .padding(.vertical, 12)
            
            Text("\(arrival.name)님, \(arrival.rank)등으로 도착하셨습니다!")
            
            Text("약속 시간\(timeDifference)\(arrivalType.rawValue) 오셨어요.")
            
            if arrivalType == .late {
                Text("다음부턴 조금 더 일찍 출발해보세요!")
                Text("\(arrival.potato)감자가 차감 될 예정입니다.")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
            }
            
            Button {
                isPresented = false
                print("Button clicked: \(isPresented)")
            } label: {
                Text("확인")
                    .bold()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .vertical], 12)
            .tint(arrivalType == .late ? .red : .blue)
        } // VStack
        .padding(.horizontal, 12)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .stroke(.brown.opacity(0.5))
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(.white)
                )
        )
        .padding(.horizontal, 28)
    } // body
} // struct

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
}
