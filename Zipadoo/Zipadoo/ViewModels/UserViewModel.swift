//
//  UserStore.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

/*
 static var dummyUser = [
     User(name: "현정", nickName: "stacy", phoneNumber: "0100000", potato: 1000, crustDepth: 300, tardyCount: 10),
     User(name: "병구", nickName: "뱅구", phoneNumber: "010202", potato: 30, crustDepth: 200, tardyCount: 5),
     User(name: "아라", nickName: "or zr", phoneNumber: "010339", potato: 200, crustDepth: 100, tardyCount: 8),
     User(name: "해수", nickName: "깃신", phoneNumber: "010234", potato: 30, crustDepth: 150, tardyCount: 5)
 ]

 */

final class UserViewModel: ObservableObject {
    
    @Published var userFetchArray: [User] = []
        
    let dbRef = Firestore.firestore().collection("Users")
    
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
    func fetchUser(nickname: String) async throws -> User? {
        let snapshot = try await dbRef.whereField("nickName", isEqualTo: nickname).getDocuments()
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: snapshot.documents[0].data(), options: []) {
            if let user = try? JSONDecoder().decode(User.self, from: jsonData) {
                return user
            }
        }
        return nil
    }
    
    /// 유저데이터 파베에 추가 함수 -> 성공 (나중에 Auth쪽으로 보내기)
    /*
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
