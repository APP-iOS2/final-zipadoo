//
//  EditProfileViewModel.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/25.
//

import SwiftUI

final class EditProfileViewModel: ObservableObject {

    var nickname: String = "유저의 닉네임"
    var phoneNumber: String = "유저의 전화번호"
    @Published var password: String = "유저의 비밀번호"
    @Published var passwordCheck: String = "비밀번호 확인"
    var profileImageString: UIImage = UIImage(imageLiteralResourceName: "images")
    
    /*
    func updateUserData() async throws {
        var data = [String: Any]()
        
        let imageUrl = try? await ProfileImageUploader.uploadImage(image: profileImageString)
        data["profileImageString"] = imageUrl
        
        if !nickname.isEmpty && user.nickName != nickname {
            data["nickName"] = nickname
            // 현재 사용자의 정보 변경
        }
        
        if !phoneNumber.isEmpty && user.phoneNumber != phoneNumber {
            data["phoneNumber"] = phoneNumber
            // ..
        }
        
        if !password.isEmpty && //비밀
    }
    */
}
