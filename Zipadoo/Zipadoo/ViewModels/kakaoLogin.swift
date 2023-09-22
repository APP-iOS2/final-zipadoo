//
//  kakaoLogin.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/22.
//

import KakaoSDKAuth
import Combine
import SwiftUI

// 카카오 로그인 후 우리 앱으로 돌아오기 위한 URL을 만들 URLHandler
// 뷰에서 사용시, @EnvironmentObject var urlHandler: URLHandler
class URLHandler: ObservableObject {
    @Published var isKakaoLoginHandled = false

    func handleURL(_ url: URL) {
        if AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
            isKakaoLoginHandled = true
        }
    }
}
