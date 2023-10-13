//
//  ArrivalMessagingView.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

enum ArrivalType: String {
    case early = "일찍"
    case last = "늦게"
    case onTime = "딱 맞춰"
}

struct ArrivalMessagingView: View {
    // MARK: - Properties
    @Binding var isPresented: Bool
    /// 사용자 이름
    let name: String
    /// 사용자 이미지
    let profileImgString: String
    /// 사용자 도착 순위
    let rank: Int
    /// 약속시간 - 사용자가 도착한 시간
    let arrivarDifference: Double
    /// 지각시 차감될 감자 수
    let potato: Int
    
    var timeDifference: String {
        let timeDiff = abs(arrivarDifference)
        switch timeDiff {
        case 0:
            return ""
        case 0..<3600:
            let minute = timeDiff / 60
            return "\(Int(minute))분 "
        case 3600..<86400:
            let hours = timeDiff / (60 * 60)
            let minute = Int(timeDiff) % (60 * 60) / 60
            var message = "\(Int(hours))시간 "
            message += minute == 0 ? "" : "\(minute)분 "
            return message
        default:
            return ""
        }
    }
    
    var arrivalType: ArrivalType {
        if arrivarDifference > 0 {
            .early
        } else if arrivarDifference < 0 {
            .last
        } else {
            .onTime
        }
    }
    
    // MARK: - body
    var body: some View {
        VStack {
            ProfileImageView(imageString: profileImgString, size: .regular)
            Text("\(name)님, \(rank)등으로 도착하셨습니다!")
            Text("약속시간 보다 " + timeDifference + arrivalType.rawValue + " 오셨어요.")
            
            if arrivalType == .last {
                Text("다음부턴 조금 더 일찍 출발해보세요!")
                Text("\(potato)감자가 차감 될 예정입니다.")
                    .font(.caption).bold()
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
            }
            
            Button {
                isPresented = false
            } label: {
                Text("확인")
                    .bold()
                    .padding(.vertical, 8)
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding([.horizontal, .vertical], 12)
        }
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
    }
}

struct ArrivalMessagingModifier: ViewModifier {
    @Binding var isPresented: Bool
    /// 사용자 이름
    let name: String
    /// 사용자 이미지
    let profileImgString: String
    /// 사용자 도착 순위
    let rank: Int
    /// 약속시간 - 사용자가 도착한 시간
    let arrivarDifference: Double
    /// 지각시 차감될 감자 수
    let potato: Int
    
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
                
                ArrivalMessagingView(isPresented: self.$isPresented, name: self.name, profileImgString: self.profileImgString, rank: self.rank, arrivarDifference: self.arrivarDifference, potato: self.potato
                )
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
    Text("약속 장소 도착 Alert")
      .modifier(
        ArrivalMessagingModifier(
            isPresented: .constant(true),
            name: "아라",
            profileImgString: "https://cdn.discordapp.com/emojis/1154686109234774058.webp?size=240&quality=lossless",
            rank: 2,
            arrivarDifference: 720.3641,
            potato: 500)
      )
}
