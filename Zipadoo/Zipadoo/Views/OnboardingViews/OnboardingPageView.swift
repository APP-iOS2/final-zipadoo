//
//  PageOneView.swift
//  Zipadoo
//
//  Created by 장여훈 on 1/4/24.
//

import SwiftUI

struct OnboardingPageView: View {
    let imageName: String
    
    var body: some View {
        GeometryReader { geometry in
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: geometry.size.width, height: geometry.size.height)
                .clipped()
        }
        .edgesIgnoringSafeArea(.horizontal)
    }
}

#Preview {
    OnboardingPageView(
        imageName: "SC 44"
    )
}
