//
//  LaunchScreen.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

/// 시작화면 LaunchScreen
struct LaunchScreen: View {
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image("Dothez")
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                    .offset(y: geometry.size.height * 0.38)
            } // GeometryReader
        } // VStack
    } // body
} // struct

#Preview {
    LaunchScreen()
}
