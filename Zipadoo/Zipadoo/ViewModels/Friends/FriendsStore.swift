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
    let currentUser: User? = AuthStore.shared.currentUser
    
    @Published var friendsIdArray: [String]
    @Published var friendsIdRequestArray: [String]
    
    init() {
        friendsIdArray = currentUser?.friendsIdArray ?? []
        friendsIdRequestArray = currentUser?.friendsIdRequestArray ?? []
    }
    
    /// 사용자의 친구 가져오기
    func fetchFriends() async throws {
        for id in friendsIdArray {
            do {
                let friend: User? = try await UserStore.fetchUser(userId: id)
                if let friend {
                    friendsFetchArray.append(friend)
                }
            } catch {
                print("fetchUser실패")
            }
        }
    }
    
    /// 친구요청 목록 가져오기
    func fetchFriendsRequest() async throws {
        for id in friendsIdRequestArray {
            do {
                let friend: User? = try await UserStore.fetchUser(userId: id)
                
                if let friend {
                    requestFetchArray.append(friend)
                }
            } catch {
                print("fetchUser실패")
            }
        }
    }
    
    /// 친구 추가
    func addFriend(friendId: String) async throws {
        
        var updateData = ["friendsIdArray": friendsIdArray + [friendId]] // 현재 친구목록 + 추가친구 id 더하기
        
        do {
            try await Firestore.firestore().collection("Users").document(currentUser?.id ?? "").updateData(updateData)

        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구 삭제
    
    
    /// 친구요청 추가
    
    
    /// 친구요청 삭제
    
    

}
