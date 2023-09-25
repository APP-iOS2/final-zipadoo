//
//  KakaoStore.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/25.
//

import SwiftUI
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class KakaoStore: ObservableObject {
    
    // 카카오 로그인
    func kakaoLogin() {
        /* if UserApi.isKakaoTalkLoginAvailable() {
         UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
         if let error = error {
         print(error)
         } else {
         print("loginWithKakaoTalk() success.")
         
         // do something
         _ = oauthToken
         }
         }
         } else {
         print("loginWithKakaoTalk() failed.")
         } */
        
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                
                // do something
                _ = oauthToken
            }
        }
    }
    
    // 카카오 사용자 정보 가져오기, 해당 코드로 유저 데이터 가져온 다음, 우리 앱 유저 객체에 넣어주면 될 것으로 보임.
    func bringkakaoUserData() {
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            } else {
                print("me() success.")
                
                // do something
                print("카카오 유저 데이터 : \(user!)")
                _ = user
            }
        }
    }
    
    // 카카오 추가 항목 동의 받고 데이터 가지고 오기, (동의 받을 필요없는 것으로 보임으로, 지금은 쓸 필요 없음)
    func kakaoDataConsent() {
        UserApi.shared.me() { (user, error) in
            if let error = error {
                print(error)
            } else {
                if let user = user {
                    var scopes = [String]()
                    if user.kakaoAccount?.profileNeedsAgreement == true { scopes.append("profile") }
                    if user.kakaoAccount?.emailNeedsAgreement == true { scopes.append("account_email") }
                    //                    if user.kakaoAccount?.birthdayNeedsAgreement == true { scopes.append("birthday") }
                    //                    if user.kakaoAccount?.birthyearNeedsAgreement == true { scopes.append("birthyear") }
                    //                    if user.kakaoAccount?.genderNeedsAgreement == true { scopes.append("gender") }
                    //                    if user.kakaoAccount?.phoneNumberNeedsAgreement == true { scopes.append("phone_number") }
                    //                    if user.kakaoAccount?.ageRangeNeedsAgreement == true { scopes.append("age_range") }
                    //                    if user.kakaoAccount?.ciNeedsAgreement == true { scopes.append("account_ci") }
                    
                    if scopes.count > 0 {
                        print("사용자에게 추가 동의를 받아야 합니다.")
                        
                        // OpenID Connect 사용 시
                        // scope 목록에 "openid" 문자열을 추가하고 요청해야 함
                        // 해당 문자열을 포함하지 않은 경우, ID 토큰이 재발급되지 않음
                        // scopes.append("openid")
                        
                        // scope 목록을 전달하여 카카오 로그인 요청
                        UserApi.shared.loginWithKakaoAccount(scopes: scopes) { (_, error) in
                            if let error = error {
                                print(error)
                            } else {
                                UserApi.shared.me() { (user, error) in
                                    if let error = error {
                                        print(error)
                                    } else {
                                        print("me() success.")
                                        
                                        // do something
                                        print("카카오 유저 데이터 : \(user!)")
                                        _ = user
                                    }
                                }
                            }
                        }
                    } else {
                        print("사용자의 추가 동의가 필요하지 않습니다.")
                    }
                }
            }
        }
        
    }
    
    // 카카오 로그아웃
    func kakaoLogout() {
        UserApi.shared.logout {(error) in
            if let error = error {
                print(error)
            } else {
                print("logout() success.")
            }
        }
    }
    
    // 카카오 계정 연결 끊기, 로그아웃 처리도 같이 이뤄짐
    func cutKakaoConnection() {
        UserApi.shared.unlink {(error) in
            if let error = error {
                print(error)
            } else {
                print("unlink() success.")
            }
        }
    }
}
