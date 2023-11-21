//
//  AuthStore.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/09/26.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

final class AuthStore: ObservableObject {
    /// 사용자 세션 저장
    @Published var userSession: FirebaseAuth.User?
    
    /// 현재 로그인된 사용자 정보 저장
    @Published var currentUser: User?
    
    /// 싱글톤 인스턴스
    static let shared = AuthStore()
    
    let dbRef = Firestore.firestore().collection("Users")
    
    init() {
        Task {
            try await loadUserData()
        }
    }
    
    /// 사용자가 로그인되어 있는지 확인
    @MainActor
    func loadUserData() async throws {
        // 현재 로그인한 사용자 가져오기
        self.userSession = Auth.auth().currentUser
        
        guard let currentUid = userSession?.uid else { return }
        
        // 토큰의 사용자 ID를 사용하여 사용자를 찾아 currentUser에 저장
        self.currentUser = try await UserStore.fetchUser(userId: currentUid)
        print("loadUserData 성공")
    }
    
    /// 이메일로 회원가입
    @MainActor
    func createUser(email: String, password: String, name: String, nickName: String, phoneNumber: String, profileImage: UIImage?, moleImageString: String) async throws {
        do {
            // 회원가입 후 사용자의 userSession에 저장
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            
            // 이미지의 경로를 저장할 변수를 초기화
            var profileImageString: String = "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
            
            // 회원가입 중에 이미지가 선택되었다면 저장하고 경로를 가져오기
            if let uiImage = profileImage {
                profileImageString = try await ProfileImageUploader.uploadImage(image: uiImage) ?? "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
            }
            
            // 사용자 정보를 Firestore에 저장
            try await addUserData(id: result.user.uid, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImageString: profileImageString, moleImageString: moleImageString)
            
            // 이메일 중복 확인을 위해 별도로 저장하는 컬렉션
            let dbRef = Firestore.firestore().collection("User email")
            try await dbRef.document(UUID().uuidString).setData(["userId": result.user.uid, "email": email])
            
            // 회원가입 후 자동으로 로그인되므로 로그인 메서드를 호출
            _ = try await self.login(email: email, password: password)
            print("회원가입 후 로그인 성공")
        } catch {
            print("회원가입 후 로그인 실패: \(error.localizedDescription)")
        }
    }
    
    /// 사용자 데이터 추가
    func addUserData(id: String, name: String, nickName: String, phoneNumber: String, profileImageString: String, moleImageString: String) async throws {
        do {
            let user = User(id: id, name: name, nickName: nickName, phoneNumber: phoneNumber, potato: 0, profileImageString: profileImageString, crustDepth: 0, tradyCount: 0, friendsIdArray: [], friendsIdRequestArray: [], moleImageString: moleImageString)
            try dbRef.document(id).setData(from: user)
            print("사용자 등록 성공")
        } catch {
            print("사용자 등록 중 오류 발생: \(error.localizedDescription)")
        }
    }
    
    /// 사용자 로그인 수행
    @MainActor
    func login(email: String, password: String) async throws -> Bool {
        // 로그인된 사용자를 userSession에 저장
        self.userSession = try await Auth.auth().signIn(withEmail: email, password: password).user
        
        // 사용자 데이터를 다시 로드
        try await loadUserData()
        print("로그인 성공")
        
        // 로그인 성공 여부를 반환
        return true
    }
    
    /// 사용자 로그아웃을 수행
    @MainActor
    func logOut() async throws {
        do {
            // 로그아웃을 수행
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("로그아웃 성공")
        } catch {
            print("로그아웃 실패")
        }
    }
}
