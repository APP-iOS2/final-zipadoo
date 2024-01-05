//
//  PageTabView.swift
//  Zipadoo
//
//  Created by 장여훈 on 1/4/24.
//

import SwiftUI

struct OnboardingPageTabView: View {
    @Binding var isFirstLaunching: Bool
    var body: some View {
        TabView {
            OnboardingPageView(
                imageName: "SC 44"
            )
            
            OnboardingPageView(
                imageName: "SC 45"
            )
            
            OnboardingPageView(
                imageName: "SC 48"
            )
            
            OnboardingLastPageView(
                imageName: "zipadoo",
                title: "",
                subtitle: "친구들과 약속 만들러 가볼까요?",
                isFirstLaunching: $isFirstLaunching
            )
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

#Preview {
    OnboardingPageTabView(isFirstLaunching: .constant(true))
}
