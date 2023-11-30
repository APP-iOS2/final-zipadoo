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
        VStack {
            Spacer()
            // MARK: - 버전정보
            
            VStack {
                Image(.zipadoo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(7)
                
                VStack(alignment: .center, spacing: 5) {
                    Text("Zipadoo")
                        .font(.title2)
                        .bold()
                    
                    Text("현재 \(appVersion)")
                        .foregroundColor(.secondary)
                }
//                Button {
//                    // App Store이동 (이후 리팩토링)
//                    /*
//                     https://velog.io/@beomsoo0/App-Version-%EB%B9%84%EA%B5%90-%ED%9B%84-%EC%95%B1%EC%8A%A4%ED%86%A0%EC%96%B4-%EC%9D%B4%EB%8F%99-Alert-%EB%9D%84%EC%9A%B0%EA%B8%B0
//                     참고
//                     */
//                } label: {
//                    Text("업데이트")
//                }
//                .buttonStyle(.automatic)
                
            } // HStack
            .padding(.bottom, 130)
            
            // MARK: - 오픈소스 라이센스
            Button {
                /// 지파두 설정창으로 이동
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsURL)
            } label: {
                HStack {
                    Text("오픈소스 라이센스")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding(6)
            }
            .buttonStyle(.bordered)
            .frame(width: 280)
            .tint(.sand)
            .padding(.bottom, 10)
            
            NavigationLink {
                DeveloperProfileView()
            } label: {
                HStack {
                    Text("개발자")
                        .foregroundColor(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                }
                .padding(6)
            }
            .buttonStyle(.bordered)
            .frame(width: 280)
            .tint(.sand)

            Spacer()
            
            Text("Copyrightⓒ 2023 Zipadoo All rights reserved")
                .font(.caption2)
                .foregroundColor(.secondary)
                .padding(.bottom, 10)
            
        } // VStack
        .padding()
        .navigationTitle("앱 정보")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppInfoView()
}
