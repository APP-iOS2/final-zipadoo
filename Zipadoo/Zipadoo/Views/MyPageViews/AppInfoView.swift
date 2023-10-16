//
//  AppInfoView.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

struct AppInfoView: View {
    
    private let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "버전 정보를 불러올 수 없습니다"
    
    var body: some View {
        VStack {
            Spacer()
            Group {
                Image(.zipadoo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .cornerRadius(7)
                
                Text("Zipadoo")
                    .font(.title)
                    .bold()
            }
            HStack {
                Text("버전정보")
                Text("\(appVersion)")
                    .foregroundColor(.gray)
            }
            
            Spacer()
            Text("Copyrightⓒ 2023 Zipadoo All rights reserved")
                .font(.caption2)
                .foregroundColor(.gray)
//                .padding()
        }
        .padding(.bottom, 50)
    }
}

#Preview {
    AppInfoView()
}
