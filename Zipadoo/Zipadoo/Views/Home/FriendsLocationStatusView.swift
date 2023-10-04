//
//  FriendsLocationStatus.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/22.
//

import SwiftUI

struct FriendsLocationStatusView: View {
    @State private var value: Double = 0.4
    let friends = ["홍길동", "둘리", "도우너", "도우너", "도우너", "도우너"]
    
    var body: some View {
        VStack {
            ForEach(friends, id: \.self) { friend in
                ProgressWithImageView(value: value, label: { Text(friend) }, currentValueLabel: { Text("\(Int(value*100))%") })
                    .progressViewStyle(BarProgressStyle(height: 25))
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))
                    .shadow(radius: 5)
            }
            HStack {
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
            }
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
