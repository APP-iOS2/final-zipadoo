//
//  UserStore.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import FirebaseCore
import FirebaseFirestore
import SwiftUI

final class UserStore: ObservableObject {
    
    @Published var userFetchArray: [User] = []
    
    @Published var currentUser: User?
    
    @Published var participantImageArray: [String] = []
        
    let dbRef = Firestore.firestore().collection("Users")
    
    init() {
        Task { try await loginUser() }

    }
    
    /// 모든 유저 정보 가져오기 -> 성공
    func fetchAllUsers() {
        
        userFetchArray.removeAll()
        
        dbRef.getDocuments { (snapshot, error) in
            // 스냅샷이 없다면 return
            guard let snapshot = snapshot else {
                print("Error fetching data: \(error?.localizedDescription ?? "fetchUserDateError")")
                return
            }
            
            var savedArray: [User] = []
            
            for document in snapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []) {
                    if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
                        savedArray.append(user)
                    }
                }
            }
            
            self.userFetchArray = savedArray
        }
    }
    
    /// 특정 유저정보 가져오기 -> 성공
    static func fetchUser(userId: String) async throws -> User? {
        
        let dbRef = Firestore.firestore().collection("Users")
        
        let snapshot = try await dbRef.document(userId).getDocument()
        
        return try snapshot.data(as: User.self)
    }
    /// 홈메인뷰 프로필이미지 가져오기 위한 함수
    func fetchImageString(participantIdArray: [String]) async throws {
        participantImageArray.removeAll()
//        let dbRef = Firestore.firestore().collection("Users")
        for id in participantIdArray {
            let snapshot = try await dbRef.document(id).getDocument()
            let string = try snapshot.data(as: User.self).profileImageString 
            participantImageArray.append(string)
        }
    }
    /// 로그인한 유저 정보 가져오기
    @MainActor
    func loginUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await dbRef.document(uid).getDocument()
        
        let user = try snapshot.data(as: User.self)
        
        self.currentUser = user
    }
    
    /*
     /// 유저데이터 파베에 추가 함수 ->  AuthStore에 있음
    func addUserData() async throws {
        do {
            // 스포리지에 저장한 사진 주소String
            guard let imageUrlString = try await ProfileImageUploader.uploadImage(image: UIImage(imageLiteralResourceName: "images")) else { return }
            
            let user = User(name: "되라구!@", nickName: "hey", phoneNumber: "13", potato: 4, profileImageString: imageUrlString, crustDepth: 2, tardyCount: 5)
            try dbRef.document(user.id).setData(from: user)
            fetchAllUsers()
            
        } catch {
            print("User 등록 실패")
        }
    }
     */

    /// 업데이트는 따로 만들어서 마이페이지쪽 ViewModel에서 구현
}
