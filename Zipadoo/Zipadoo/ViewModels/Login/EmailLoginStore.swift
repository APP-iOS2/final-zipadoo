//
//  LoginStore.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import Foundation

final class EmailLoginStore: ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    /// 선택한 프로필 이미지 UIImage
    @Published var selectedImage: UIImage?
    /// 두더지 이미지 랜덤 초기화
    @Published var moleImageString: String
    
    let dbRef = Firestore.firestore().collection("Users")
    /// 두더지 이미지 랜덤 초기화
    init() {
        let randomMoleImageString: [String] = ["doo1", "doo2", "doo3", "doo4", "doo5", "doo6", "doo7", "doo8", "doo9"]
        moleImageString = randomMoleImageString.randomElement() ?? "doo1"
    }
    
    /// 유저 회원가입
    func createUser() async throws {
        try await AuthStore.shared.createUser(email: email, password: password, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImage: selectedImage, moleImageString: moleImageString)
    }
    
    /// 유저 로그인
    func login() async throws -> Bool {
        try await AuthStore.shared.login(email: email, password: password)
    }
    
    /// 이메일 중복 체크 (기존 회원 여부)
    func emailCheck(email: String, completion: @escaping (Bool) -> Void) {
        
        let userDB = Firestore.firestore().collection("User email")
        
        // 입력한 이메일이 있는지 확인하는 쿼리
        userDB.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                // 오류 발생 시 false를 반환
                completion(false)
                return
            }
            
            // 중복된 이메일이 없으면 querySnapshot은 비어 있을 것입니다.
            if querySnapshot?.isEmpty == true {
                print("이메일 데이터 중복 없음, 회원 가입 뷰로 진행")
                // 중복된 이메일이 없을 경우 true를 반환
                completion(true)
            } else {
                print("이메일 데이터 중복 있음, 로그인 뷰로 진행")
                // 중복된 이메일이 있을 경우 false를 반환
                completion(false)
            }
        }
        
        /*
         // signInMethods가 계속 nil로 받아와짐..
         Auth.auth().fetchSignInMethods(forEmail: email) { (signInMethods, error) in
         if let error = error {
         print("이메일중복 확인 중 오류")
         completion(false)
         return
         } else if let result = signInMethods {
         if result.isEmpty {
         print("이메일 데이터 중복 없음, 회원 가입 뷰로 진행")
         completion(true)
         } else {
         print("이메일 데이터 중복 있음, 로그인 뷰로 진행")
         completion(false)
         }
         }
         completion(true)
         print("nil, nil반환")
         }
         */
    }
    
    // 닉네임 중복체크
    func nicknameCheck(completion: @escaping (Bool) -> Void) {
        dbRef.whereField("nickName", isEqualTo: nickName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 false를 반환
                return
            }
            // 중복된 닉네임이 없으면 querySnapshot은 비어 있을 것입니다.
            if querySnapshot?.isEmpty == true {
                print("중복되는 닉네임 없음")
                completion(false) // 중복된 이메일이 없을 경우 false를 반환
            } else {
                print("중복되는 닉네임 있음")
                completion(true) // 중복된 이메일이 있을 경우 true를 반환
            }
        }
    }
}
