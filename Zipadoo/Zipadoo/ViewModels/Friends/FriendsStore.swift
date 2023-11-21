//
//  FriendsStore.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/10.
//

import SwiftUI
import Firebase
import FirebaseFirestore

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
    
    @Published var alertMessage: String = ""
    @Published var isLoadingFriends: Bool = true
    @Published var isLoadingRequest: Bool = true
    
    let dbRef = Firestore.firestore().collection("Users")
    
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
            
            // 중복 친구 ID를 제거합니다.
            let uniqueFriendsIdArray = Array(Set(friendsIdArray))
            
            // 친구 id로 친구정보 가져오기
            var tempArray: [User] = []
            
            for id in uniqueFriendsIdArray {
                let friend: User? = try await UserStore.fetchUser(userId: id)
                if let friend {
                    tempArray.append(friend)
                }
            }
            
            // 메인 스레드에서 UI 업데이트를 수행합니다.
            DispatchQueue.main.async {
                self.friendsFetchArray = tempArray
                self.isLoadingFriends = false
            }
            
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
            
            // 요청목록 가져오기
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
                self.isLoadingRequest = false
            }
            
        } catch {
            print("fetchUser실패")
        }
        
    }
    
    /// 친구 닉네임으로 친구id 가져오기
    @MainActor
    func findFriend(friendNickname: String, completion: @escaping (Bool) -> Void) async throws {
        
        let snapshot = dbRef.whereField("nickName", isEqualTo: friendNickname)
        
        do {
            try await fetchFriends()
            try await fetchFriendsRequest()
            
            guard let userId = currentUser?.id else {
                return
            }
            
            // 해당 닉네임이 없으면 false반환
            let querySnapshot = try await snapshot.getDocuments()
            if querySnapshot.isEmpty {
                print("해당 닉네임 가진 친구 없음")
                alertMessage = "해당 닉네임을 가진 사용자가 없습니다"
                completion(false) // 중복된 닉네임이 없을 경우 false를 반환
            } else {
                // 닉네임이 있으면 조건 따진 후 addRequest 함수 실행
                guard let document = querySnapshot.documents.first else {
                    return
                }
                let friendId = document.documentID // 친구 아이디
                // 친구 정보 가져오기
                let opponent: User? = try await UserStore.fetchUser(userId: friendId)
                guard let opponent else {
                    return
                }
                
                if friendId == userId {
                    // 내 아이디인 경우
                    print("나의 아이디 입력")
                    alertMessage = "본인에게는 친구요청 할 수 없습니다"
                    completion(false)
                } else if friendsIdArray.contains(friendId) {
                    // 이미 친구인 경우
                    print("이미 친구")
                    alertMessage = "이미 친구입니다"
                    completion(false)
                    
                } else if opponent.friendsIdRequestArray.contains(userId) {
                    // 이미 요청한 경우
                    print("이미 요청")
                    alertMessage = "이미 요청한 친구입니다"
                    completion(false)
                } else if friendsIdRequestArray.contains(friendId) {
                    // 나에게 요청한 친구의 경우
                    print("나에게 이미 요청")
                    alertMessage = "이미 요청받은 친구입니다\n요청목록에서 확인해주세요"
                    completion(false)
                } else {
                    // 조건에 맞는 경우
                    print("조건에 맞음!")
                    try await addRequest(friendId: friendId)
                    completion(true)
                }
                
            }
        } catch {
            return
        }
    }
    
    /// 친구 추가
    func addFriend(friendId: String) async throws {
        do {
            try await fetchFriends()
            try await fetchFriendsRequest()
            
            var updateData = [String: Any]()
            
            let newIdArray = friendsIdArray + [friendId]
            updateData["friendsIdArray"] = newIdArray // 현재 친구목록 + 추가친구 id 더하기
            
            let newIdRequestArray = friendsIdRequestArray.filter { $0 != friendId }
            updateData["friendsIdRequestArray"] = newIdRequestArray
            
            // 현재 사용자 id, 친구 정보 가져오는거 실패하면 return
            let opponent: User? = try await UserStore.fetchUser(userId: friendId)
            guard let userId = currentUser?.id else {
                return
            }
            guard let opponent else {
                return
            }
            try await dbRef.document(userId).updateData(updateData)
            
            // 친구쪽 추가
            let updateOpponentData = ["friendsIdArray": opponent.friendsIdArray + [userId]]
            try await dbRef.document(opponent.id).updateData(updateOpponentData)
            
            // 다시 친구목록 업데이트
            //            currentUser?.friendsIdArray = newIdArray
            //            friendsIdArray = currentUser?.friendsIdArray ?? []
            
            try await fetchFriends()
            try await fetchFriendsRequest()
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구 삭제
    func removeFriend(friendId: String) async throws {
        do {
            try await fetchFriends()
            
            let newIdArray = friendsIdArray.filter { $0 != friendId }
            let updateData = ["friendsIdArray": newIdArray]
            
            // 현재 사용자 id, 친구 정보 가져오는거 실패하면 return
            let opponent: User? = try await UserStore.fetchUser(userId: friendId)
            guard let userId = currentUser?.id else {
                return
            }
            guard let opponent else {
                return
            }
            
            // 유저정보 업데이트
            try await dbRef.document(userId).updateData(updateData)
            // 친구쪽 삭제
            let updateOpponentData = ["friendsIdArray": opponent.friendsIdArray.filter { $0 !=  userId}]
            try await dbRef.document(opponent.id).updateData(updateOpponentData)
            
            // friendsIdArray 업데이트
            //            currentUser?.friendsIdArray = newIdArray
            //            friendsIdArray = currentUser?.friendsIdArray ?? []
            
            try await fetchFriends()
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구에게 친구요청
    func addRequest(friendId: String) async throws {
        
        do {
            // 친구의 friendIdrequestArray가져오기
            let opponent = try await UserStore.fetchUser(userId: friendId)
            guard let userId = currentUser?.id else {
                return
            }
            guard let opponent else {
                return
            }
            let requestArray = opponent.friendsIdRequestArray
            
            // 친구 요청목록 업데이트
            let newIdRequestArray = requestArray + [userId]
            let updateData = ["friendsIdRequestArray": newIdRequestArray] // 현재 친구목록 + 추가친구 id 더하기
            
            try await dbRef.document(friendId).updateData(updateData)
            
            // 다시 요청목록 업데이트
            //            currentUser?.friendsIdRequestArray = newIdRequestArray
            //            friendsIdRequestArray = currentUser?.friendsIdRequestArray ?? []
            // 다시 패치
            //            try await self.fetchFriendsRequest()
            
        } catch {
            print("파이어베이스 업데이트 실패")
        }
    }
    
    /// 친구요청 거절
    func removeRequest(friendId: String) async throws {
        
        do {
            try await fetchFriendsRequest()
            
            guard let userId = currentUser?.id else {
                return
            }
            
            // 요청목록 업데이트
            let newIdRequestArray = friendsIdRequestArray.filter { $0 != friendId }
            let updateData = ["friendsIdRequestArray": newIdRequestArray]
            try await Firestore.firestore().collection("Users").document(userId).updateData(updateData)
            
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

extension FriendsStore {
    static let sampleData: User = .init(id: "12345", name: "홍길동", nickName: "길동이", phoneNumber: "0101234", profileImageString: "https://img.newspim.com/news/2017/01/31/1701311632536400.jpg", crustDepth: 3, friendsIdArray: [], friendsIdRequestArray: [], moleImageString: "doo1") 
}
