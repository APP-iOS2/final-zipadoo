//
//  LoginStore.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

final class EmailLoginStore: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedImage: UIImage?
    @Published var moleImageString: String
    
    // Firestore 컬렉션
    private let userDB = Firestore.firestore().collection("User email")
    private let dbRef = Firestore.firestore().collection("Users")
    
    // 초기화 메서드 - 무작위로 선택된 두더지 이미지 문자열을 초기화
    init() {
        let randomMoleImageString: [String] = ["doo1", "doo2", "doo3", "doo4", "doo5", "doo6", "doo7", "doo8", "doo9"]
        moleImageString = randomMoleImageString.randomElement() ?? "doo1"
    }
    
    /// 사용자 생성 메서드 - AuthStore를 통해 사용자 생성
    func createUser() async throws {
        try await AuthStore.shared.createUser(
            token: token,
            email: email,
            password: password,
            name: name,
            nickName: nickName,
            phoneNumber: phoneNumber,
            profileImage: selectedImage,
            moleImageString: moleImageString
        )
    }
    
    /// 사용자 로그인 메서드 - AuthStore를 통해 사용자 로그인 시도
    func login() async throws -> Bool {
        try await AuthStore.shared.login(email: email, password: password)
    }
    
    /// 이메일 중복 체크
    func emailCheck(email: String, completion: @escaping (Bool) -> Void) {
        // User email 컬렉션에서 입력한 이메일이 존재하는지 확인
        userDB.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false)
                return
            }
            // 이메일이 중복되지 않으면 true 반환
            completion(querySnapshot?.isEmpty == true)
        }
    }
    
    /// 닉네임 중복 체크
    func nicknameCheck(completion: @escaping (Bool) -> Void) {
        // Users 컬렉션에서 입력한 닉네임이 존재하는지 확인
        dbRef.whereField("nickName", isEqualTo: nickName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 false를 반환
                return
            }
            // 닉네임이 중복되면 true 반환
            completion(querySnapshot?.isEmpty == false)
        }
    }
}
