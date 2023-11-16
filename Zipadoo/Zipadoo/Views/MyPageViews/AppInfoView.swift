//
//  AppInfoView.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

struct AppInfoView: View {
    /// 앱버전 문구(Project -> General -> Version에서 확인)
    private let appVersion: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "버전 정보를 불러올 수 없습니다"
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(.zipadoo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .cornerRadius(7)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Zipadoo")
                        .font(.title3)
                        .bold()
                    
                        Text("현재 \(appVersion)")
                            .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button {
                    // App Store이동 (이후 리팩토링)
                    /*
                     https://velog.io/@beomsoo0/App-Version-%EB%B9%84%EA%B5%90-%ED%9B%84-%EC%95%B1%EC%8A%A4%ED%86%A0%EC%96%B4-%EC%9D%B4%EB%8F%99-Alert-%EB%9D%84%EC%9A%B0%EA%B8%B0
                     참고
                     */
                } label: {
                    Text("업데이트")
                }
                .buttonStyle(.automatic)
            } // HStack
            .padding()
            
            Spacer()
        } // VStack
        .navigationTitle("앱 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
