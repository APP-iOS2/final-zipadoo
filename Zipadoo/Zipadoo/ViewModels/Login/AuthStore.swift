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
    
    /// 파베 토큰 저장
    @Published var userSession: FirebaseAuth.User?
    
    /// 현재 로그인 된 사용자 User
    @Published var currentUser: User?
    
    /// 싱글톤
    static let shared = AuthStore()
    
    let dbRef = Firestore.firestore().collection("Users")
    
    // email로그인에서는 아래 변수들 사용 안함
    /*
    @Published var email: String = ""
    @Published var name: String = ""
    @Published var nickName: String = ""
    @Published var phoneNumber: String = ""
    @Published var profileImage: URL = URL(string: "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png")! // 기본값 애플이미지
    */
    
    init() {
        Task {
            try await loadUserData()
        }
    }
    
    /// 유저로그인되어있는지 확인
    @MainActor
    func loadUserData() async throws {
        do {
            // 현재 로그인한 사용자 가져오기
            self.userSession = Auth.auth().currentUser
            
            guard let currentUid = userSession?.uid else { return }
            
            // 토큰의 유저 id로 User찾은 후 currentUser에 저장
            self.currentUser = try await UserStore.fetchUser(userId: currentUid)
            
            print("loadUserData 성공")
            
        } catch {
            print("loadUserData()실패 : 토큰 가져오기 실패!")
        }
        
    }
    
    /// email 회원가입
    @MainActor
    func createUser(email: String, password: String, name: String, nickName: String, phoneNumber: String, profileImage: UIImage?, moleImageString: String) async throws {
        
        do {
            // 회원가입후 그 유저 userSession에 저장
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            // 이미지의 파베경로
            var profileImageString: String = "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
            
            // 회원가입에서 선택된 이미지가 있으면 스토리지에 저장후 경로 가져오기
            if let uiImage = profileImage {
                profileImageString = try await ProfileImageUploader.uploadImage(image: uiImage) ?? "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
            }
            
            // 파베에 유저정보 저장
            try await addUserData(id: result.user.uid, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImageString: profileImageString, moleImageString: moleImageString)
            
            // 이메일 따로 저장하는 collection -> 이메일중복 확인 위해서
            let dbRef = Firestore.firestore().collection("User email")
            try await dbRef.document(UUID().uuidString).setData(["userId": result.user.uid, "email": email])
            
            // 회원가입후 로그인으로 간주해야하니까 로그인도 호출 -> 파이어베이스는 회원가입시 자동으로 로그인된다고 함.
            _ = try await self.login(email: email, password: password)
            print("회원가입 후 로그인 성공~")

        } catch {
            print("DEBUG: Failed to register user with error \(error.localizedDescription)")
        }

    }
    
    /// 로그인 스토어 데이터를 받아서 파이어베이스에 보내기 (email, 카카오, 애플)
    func addUserData(id: String, name: String, nickName: String, phoneNumber: String, profileImageString: String, moleImageString: String) async throws {
        do {
            let user = User(id: id, name: name, nickName: nickName, phoneNumber: phoneNumber, potato: 0, profileImageString: profileImageString, crustDepth: 0, tradyCount: 0, friendsIdArray: [], friendsIdRequestArray: [], moleImageString: moleImageString)
            try dbRef.document(id).setData(from: user)
            
        } catch {
            print("User 등록 실패")
        }
    }
    
    /// 로그인
    @MainActor
    func login(email: String, password: String) async throws -> Bool {

        // 로그인한 유저 userSession에 저장
        self.userSession = try await Auth.auth().signIn(withEmail: email, password: password).user
        
        try await loadUserData()
        print("로그인 성공!")
  
        // 로그인 성공 여부 반환 필요
        return true
    }
    
    /// 로그아웃
    @MainActor
    func logOut() async throws {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            print("로그아웃 성공")
        } catch {
            print("로그아웃실패")
        }
    }
}
