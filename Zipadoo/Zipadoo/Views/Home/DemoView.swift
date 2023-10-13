//
//  DemoView.swift
//  Zipadoo
//
//  Created by 임병구 on 10/13/23.
//
//  ContentView.swift
//  cardPractice
//
//  Created by 임병구 on 10/13/23.
//

import SwiftUI

struct DemoView: View {
    @State private var currentIndex: Int = 0
    @GestureState private var dragOffset: CGFloat = 0
    private var images: [String] = ["image1", "image2", "image3", "image4", "image5"]
    private let imageSpacing: CGFloat = 50  // 사진 간격을 조절할 값
    
    var body: some View {
        NavigationStack {
        VStack {
            ZStack {
                ForEach(0..<images.count, id: \.self) { index in
                    Image(images[index])
                        .frame(width: 300, height: 400)
                        .cornerRadius(25)
                        .opacity(currentIndex == index ? 1.0 :0.5)
                        .scaleEffect(currentIndex == index ? 1.2 : 0.8)
                        .offset(x: 0, y: (CGFloat(index - currentIndex) * (400 + imageSpacing)) + dragOffset)
                       
                }
                
            }
            .gesture(
                DragGesture()
                    .onEnded({ value in
                        let threshold: CGFloat = 50
                        if value.translation.height > threshold {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                            }
                        } else if value.translation.height < -threshold { withAnimation {
                            currentIndex = min(images.count - 1, currentIndex + 1)
                        }
                        }
                    })
            )
        } // Vstack
               
                }
        }
    }


#Preview {
    DemoView()
}
