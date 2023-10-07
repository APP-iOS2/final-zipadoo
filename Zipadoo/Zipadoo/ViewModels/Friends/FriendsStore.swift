//
//  FriendsStore.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/06.
//

import Firebase
import SwiftUI

/// 친구등록, 친구불러오기
final class FriendsStore: ObservableObject {
    /// 현재 로그인된 사용자의 친구들
    @Published var friendsFetchArray: [User] = []
    /// 친구요청한 친구들
    @Published var requestFetchArray: [User] = []
    /// 로그인된 사용자
    var currentUser: User? = AuthStore.shared.currentUser
    
    var friendsIdArray: [String] = []
    var friendsIdRequestArray: [String] = []
    
    /*
    init() async throws {
//        friendsIdArray = currentUser?.friendsIdArray ?? []
//        friendsIdRequestArray = currentUser?.friendsIdRequestArray ?? []
        do {
            try await self.fetchFriends()
            try await self.fetchFriendsRequest()
        } catch {
            print("히히")
        }
    }
     */
    
    /// 사용자의 친구 가져오기
    @MainActor
    func fetchFriends() async throws {
        
        do {
            // 사용자id로 친구id배열가져오기
            guard let userId = currentUser?.id else {
                return
            }
            let user = try await UserStore.fetchUser(userId: userId)
            friendsIdArray = user?.friendsIdArray ?? []
            
            // 친구 id로 친구정보 가져오기
            var tempArray: [User] = []
            
            for id in friendsIdArray {
                let friend: User? = try await UserStore.fetchUser(userId: id)
                if let friend {
                    tempArray.append(friend)
                }
            }
            
            // 메인 스레드에서 UI 업데이트를 수행합니다.
            DispatchQueue.main.async {
                self.friendsFetchArray = tempArray
            }
            print(friendsFetchArray)
 
        } catch {
            print("fetch 실패")
        }
    }
    
    /// 친구요청 목록 가져오기
    @MainActor
    func fetchFriendsRequest() async throws {
        do {
            // 사용자id로 친구id배열가져오기
            guard let userId = currentUser?.id else {
                return
            }
            let user = try await UserStore.fetchUser(userId: userId)
            friendsIdRequestArray = user?.friendsIdRequestArray ?? []
            
            var tempArray: [User] = []

            for id in friendsIdRequestArray {
                
                let friend: User? = try await UserStore.fetchUser(userId: id)
                
                if let friend {
                    tempArray.append(friend)
                }
            }
            
            // 메인 스레드에서 UI 업데이트를 수행합니다.
            DispatchQueue.main.async {
                self.requestFetchArray = tempArray
            }
                
        } catch {
            print("fetchUser실패")
        }
        
    }
    
    /// 친구 추가
    func addFriend(friendId: String) async throws {
        let newIdArray = friendsIdArray + [friendId]
        var updateData = ["friendsIdArray": newIdArray] // 현재 친구목록 + 추가친구 id 더하기
        
        do {
            
            try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(updateData)
            
            // 다시 친구목록 업데이트
            currentUser?.friendsIdArray = newIdArray
            friendsIdArray = currentUser?.friendsIdArray ?? []
            // 다시 패치
            try await self.fetchFriends()
            
            // 친구쪽 추가
            let opponent: User? = try await UserStore.fetchUser(userId: friendId)
            if let user = opponent {
                let updateOpponentData = ["friendsIdArray": user.friendsIdArray + [user.id]]
                try await Firestore.firestore().collection("Users").document(user.id).updateData(updateData)
            }
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구 삭제
    func removeFriend(friendId: String) async throws {
        let newIdArray = friendsIdArray.filter { $0 != friendId }
        var updateData = ["friendsIdArray": newIdArray]
        print(friendsFetchArray)
        do {
            // 현재 사용자 id, 친구 정보 가져오는거 실패하면 return
            var opponent: User? = try await UserStore.fetchUser(userId: friendId)
            guard let userId = currentUser?.id else {
                return
            }
            guard let opponent else {
                return
            }
            
            // 유저정보 업데이트
            try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(updateData)
            // 친구쪽 삭제
            let updateOpponentData = ["friendsIdArray": opponent.friendsIdArray.filter { $0 !=  userId}]
            try await Firestore.firestore().collection("Users").document(opponent.id).updateData(updateOpponentData)

            // friendsIdArray 업데이트
            currentUser?.friendsIdArray = newIdArray
            friendsIdArray = currentUser?.friendsIdArray ?? []
            
            // 다시 패치
            try await self.fetchFriends()
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구요청 추가
    func addRequest(friendId: String) async throws {
        let newIdRequestArray = friendsIdArray + [friendId]
        var updateData = ["friendsIdRequestArray": newIdRequestArray] // 현재 친구목록 + 추가친구 id 더하기
        
        do {
            try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(updateData)
            
            // 다시 요청목록 업데이트
            currentUser?.friendsIdRequestArray = newIdRequestArray
            friendsIdRequestArray = currentUser?.friendsIdRequestArray ?? []

            // 다시 패치
            try await self.fetchFriendsRequest()
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구요청 삭제
    func removeRequest(friendId: String) async throws {
        let newIdRequestArray = friendsIdArray.filter { $0 != friendId }
        var updateData = ["friendsIdRequestArray": newIdRequestArray]
        
        do {
            try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(updateData)
            
            // 다시 요청목록 업데이트
            currentUser?.friendsIdRequestArray = newIdRequestArray
            friendsIdRequestArray = currentUser?.friendsIdRequestArray ?? []

            // 다시 패치
            try await self.fetchFriendsRequest()
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
}
