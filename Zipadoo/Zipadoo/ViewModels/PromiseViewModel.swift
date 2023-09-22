//
//  PromiseViewModel.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/22.
//

import Foundation
import Firebase

class PromiseViewModel: ObservableObject {
    @Published var promiseViewModel: [Promise] = []
    
    private let dbRef = Firestore.firestore().collection("Promise")
    
    init() {
        
    }
    
    // MARK: - 약속 패치 함수
    /// 약속 패치 함수
    func fetchPromise() async throws {
        self.promiseViewModel.removeAll()
        
        do {
            let snapshot = try await dbRef.getDocuments()
            
            for document in snapshot.documents {
                let data = document.data()
                print("Document data: \(data)")
                
                // Firebase document 맵핑
                let id = document.documentID
                let makingUserID = data["makingUserID"] as? String ?? ""
                let destination = data["destination"] as? String ?? ""
                let promiseTitle = data["promiseTitle"] as? String ?? ""
                let participantIdArray = data["participantIdArray"] as? [String] ?? []
                let promiseDate = data["promiseDate"] as? Double ?? 0.0
                let checkDoublePromise = data["checkDoublePromise"] as? Bool ?? false
                let locationIdArray = data["locationIdArray"] as? [String] ?? []
                
                let promise = Promise(
                    id: id,
                    makingUserID: makingUserID,
                    destination: destination,
                    promiseTitle: promiseTitle,
                    participantIdArray: participantIdArray,
                    promiseDate: promiseDate,
                    checkDoublePromise: checkDoublePromise,
                    locationIdArray: locationIdArray
                )
                
                // promiseViewModel에 추가
                self.promiseViewModel.append(promise)
            }
        } catch {
            print("Error getting documents: \(error)")
        }
    }
    
    //MARK: - 약속 수정 함수
    func editPromise(promiseTitle: String, ) {
        
    }
    
    //MARK: - 약속 삭제 함수
    func deletePromise() {
        
    }
}

/*
 participantIdArray에 ID 값과 같은 사람들만 가져온다.
 guard let userID =
 */
