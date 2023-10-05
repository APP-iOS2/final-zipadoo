//
//  LoginStore.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import Firebase
import FirebaseFirestore
import Foundation
import SwiftUI

class EmailLoginStore: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    /// 선택한 프로필 이미지 UIImage
    @Published var selectedImage: UIImage?
    
    /// 유저 회원가입
    func createUser() async throws {
        
        try await AuthStore.shared.createUser(email: email, password: password, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImage: selectedImage)
        
    }
    
    /// 유저 로그인
    func login() async throws -> Bool {
        try await AuthStore.shared.login(email: email, password: password)
    }
    
    // 이메일 중복 체크 (기존 회원 여부)
    func emailCheck(email: String, completion: @escaping (Bool) -> Void) {
        
        let userDB = Firestore.firestore().collection("User email")
        
        // 입력한 이메일이 있는지 확인하는 쿼리
        userDB.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 false를 반환
                return
            }
            
            // 중복된 이메일이 없으면 querySnapshot은 비어 있을 것입니다.
            if querySnapshot?.isEmpty == true {
                print("이메일 데이터 중복 없음, 회원 가입 뷰로 진행")
                completion(true) // 중복된 이메일이 없을 경우 true를 반환
            } else {
                print("이메일 데이터 중복 있음, 로그인 뷰로 진행")
                completion(false) // 중복된 이메일이 있을 경우 false를 반환
            }
        }
         
        /*
        print("\(email)")
        Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
            if let error = error {
                print(error)
                completion(false)
                return
            } else if let _ = signInMethods {
                print("중복 이메일")
                completion(false)
            } else {
                print("새로운 이메일")
                completion(true)
            }
        }
         */
    }
    
    /// 이메일 유효한 형식인지 확인
    func isCorrectEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailPredicate.evaluate(with: email)
    }
    
    /// 닉네임 유효한 형식 확인
    func isCorrectNickname() -> Bool {
        let nicknameRegex = "[A-Za-z0-9]{2,6}"
        let nicknamePredicate = NSPredicate(format: "SELF MATCHES %@", nicknameRegex)
        
        return nicknamePredicate.evaluate(with: nickName)
    }
    
    /// 전화번호 유효한 형식 확인
    func isCorrectPhoneNumber() -> Bool {
        let passwordRegex = "01([0-9])([0-9]{3,4})([0-9]{4})$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        return passwordPredicate.evaluate(with: phoneNumber)
    }
    
    /// 비밀번호 유효한 형식 확인
    func isCorrectPassword() -> Bool {
//        let passwordRegex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{6,16}$"
        let passwordRegex = ".{6,15}$" // 6 ~ 15 자리
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegex)

        return passwordPredicate.evaluate(with: password)
    }
}
