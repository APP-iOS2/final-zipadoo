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
    /// 유저의 현재 정보를 확인하기 위한 변수
    @Published var currentUser: User?
    /// 파이어 베이스 User 데이터베이스
    let dbRef = Firestore.firestore().collection("Users")
    /// 기본 이미지
    let defaultImageString = "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
    init() {
        Task { try await loginUser() }

    }
    
    /// 특정 유저정보 가져오기 -> 성공
    static func fetchUser(userId: String) async throws -> User? {
        
        let dbRef = Firestore.firestore().collection("Users")
        do {
            let snapshot = try await dbRef.document(userId).getDocument()
            print("UserStore.fetchUser성공")
            return try snapshot.data(as: User.self)
        } catch {
            print(#function, "try await dbRef.document(userId).getDocument() 실패")
            throw error
        }
    }
    
    /// 홈메인뷰 프로필이미지 가져오기 위한 함수
    @MainActor
    func fetchImageString(participantIdArray: [String]) async throws -> [String] {
        var tempArray: [String] = []
        for id in participantIdArray {
            let snapshot = try await dbRef.document(id).getDocument()
            let string = try snapshot.data(as: User.self).profileImageString 
            tempArray.append(string)
            
        }
        return tempArray
    }
    
    /// 로그인한 유저 정보 가져오기
    @MainActor
    func loginUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try await dbRef.document(uid).getDocument()
        
        let user = try snapshot.data(as: User.self)
        
        self.currentUser = user
    }
    
    /// 유저 정보 업데이트(회원정보 수정에 사용)
    @MainActor
    func updateUserData(image: UIImage?, nick: String, phone: String) async throws {
        var data = [String: Any]()
        
        // 선택한 사진이 있다면
        if let uiImage = image {
            let imageString = try? await ProfileImageUploader.uploadImage(image: uiImage)
            data["profileImageString"] = imageString ?? defaultImageString
        }
        // 닉네임이 바뀌었다면
        if currentUser?.nickName != nick {
            data["nickName"] = nick
        }
        // 전화번호가 바뀌었다면
        if currentUser?.phoneNumber != phone {
            data["phoneNumber"] = phone
        }
        
        // 바뀐 사항이 하나라도 있다면 파이어베이스에 업데이트
        if !data.isEmpty {
            do {
                print(currentUser?.id ?? "")
                try await dbRef.document(currentUser?.id ?? "").updateData(data)
            } catch {
                print("파이어베이스 업데이트 실패")
            }
        }
    }
    
    /// 비밀번호 변경 함수
    @MainActor
    func updatePassword(newValue newpassword: String) async throws {
        do {
            try await Auth.auth().currentUser?.updatePassword(to: newpassword)
        } catch {
            print("비밀번호 변경 실패")
        }
    }
    /// 유저 이미지 업데이트
    func getUserProfileImage() -> String {
        guard let urlString = currentUser?.profileImageString else { return "" }
        return urlString
    }
    
    /// 유저 지각횟수, 약속 수 계산후 업데이트
    static func updatePromiseTradyCount(promiseDate: Double, arriveTime: Double) async throws {
        do {
            print("updateTradyFunc")
            var data = [String: Any]()
            let userData = try await UserStore.fetchUser(userId: AuthStore.shared.currentUser?.id ?? "no id")
            let timeDiff = promiseDate - arriveTime
            var updateTradyCount = 0
            if timeDiff <= 0 && timeDiff > -60 {
                updateTradyCount = userData?.tradyCount ?? 0
            } else if timeDiff < 0 {
                updateTradyCount = (userData?.tradyCount ?? 0) + 1
            } else {
                updateTradyCount = userData?.tradyCount ?? 0
            }
            let updatePromiseCount = (userData?.promiseCount ?? 0) + 1
            data["tradyCount"] = updateTradyCount
            data["promiseCount"] = updatePromiseCount
            
            try await Firestore.firestore().collection("Users").document(AuthStore.shared.currentUser?.id ?? "no id").updateData(data)
            
            AuthStore.shared.currentUser?.tradyCount = updateTradyCount
            AuthStore.shared.currentUser?.promiseCount = updatePromiseCount
        } catch {
            print("유저 지각횟수, 약속 수 업데이트 실패")
        }
    }
}
