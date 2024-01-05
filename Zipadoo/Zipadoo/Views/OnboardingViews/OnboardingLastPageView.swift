//
//  OnboardingLastPageView.swift
//  Zipadoo
//
//  Created by 장여훈 on 1/4/24.
//

import SwiftUI

struct OnboardingLastPageView: View {
    let imageName: String
    let title: String
    let subtitle: String
    @Binding var isFirstLaunching: Bool
    
    var body: some View {
        VStack {
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200, height: 200)
                .padding()
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            Text(subtitle)
                .font(.title2)
            
            Button {
                isFirstLaunching.toggle()
            } label: {
                Text("회원가입하기")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(6)
            }
            .padding()
        }
    }
}

#Preview {
    OnboardingLastPageView(imageName: "zipadoo",
                           title: "",
                           subtitle: "서브텍스트",
                           isFirstLaunching: .constant(true))
}
