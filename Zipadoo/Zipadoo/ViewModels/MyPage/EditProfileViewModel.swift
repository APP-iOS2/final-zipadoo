//
//  EditProfileViewModel.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI
import Firebase
import FirebaseFirestore

final class EditProfileViewModel: ObservableObject {
    /// 로그인된 유저정보
    let currentUser: User? = AuthStore.shared.currentUser

    /// 파이어베이스에 저장된 사진경로 String
    var profileImageString: String
    @Published var nickname: String
    @Published var phoneNumber: String
    @Published var newpassword: String = ""
    @Published var newpasswordCheck: String = ""
    
    /// 이미지 피커에서 선택한 사진
    @Published var selectedImage: UIImage?

    var defaultImageString = "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
    
    init() {
        profileImageString = currentUser?.profileImageString ?? defaultImageString
        nickname = currentUser?.nickName ?? "정보가 없습니다"
        phoneNumber = currentUser?.phoneNumber ?? "정보가 없습니다"
    }
    
    /// 유저정보 파이어베이스에 업데이트
    @MainActor
    func updateUserData(nick: String, phone: String) async throws {
        var data = [String: Any]()
        
        // 선택한 사진이 있다면
        if let uiImage = selectedImage {
            let imageString = try? await ProfileImageUploader.uploadImage(image: uiImage)
            data["profileImageString"] = imageString ?? defaultImageString
            // 현재 사용자의 정보 변경
            AuthStore.shared.currentUser?.profileImageString = imageString ?? defaultImageString
        }
        
        if currentUser?.nickName != nick {
            data["nickName"] = nick
            AuthStore.shared.currentUser?.nickName = nick
        }
        
        if currentUser?.phoneNumber != phoneNumber {
            data["phoneNumber"] = phoneNumber
            AuthStore.shared.currentUser?.phoneNumber = phoneNumber
        }
        
        // 바뀐 사항이 하나라도 있다면 파이어베이스에 업데이트
        if !data.isEmpty {
            do {
                try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(data)
            } catch {
                print("파이어베이스 업데이트 실패")
            }
        }
    }

    /// 비밀번호 업데이트
    @MainActor
    func updatePassword() async throws {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newpassword)
        } catch {
            print("비밀번호 변경 실패")
        }
    }
}
