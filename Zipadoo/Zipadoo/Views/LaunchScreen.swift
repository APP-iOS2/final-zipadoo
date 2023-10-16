//
//  LaunchScreen.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

struct LaunchScreen: View {
    var body: some View {
        VStack {
            GeometryReader { geometry in
                Image(.zipadoo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height * 0.2)
                    .offset(y: geometry.size.height * 0.38)
            }
        }
    }
}

#Preview {
    LaunchScreen()
}
