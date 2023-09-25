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
        Task {
            try await fetchPromise()
        }
    }
    
    // MARK: - 약속 패치 함수
    /// 약속 패치 함수
    func fetchPromise() async throws {
        self.promiseViewModel.removeAll()
                
        /*
         participantIdArray에 ID 값과 같은 사람들만 가져온다.
         guard let userID =
         */

        do {
            let snapshot = try await dbRef.getDocuments()
            
            for document in snapshot.documents {
                let data = document.data()
                print("Document data: \(data)")
                
                // Firebase document 맵핑
                let makingUserID = data["makingUserID"] as? String ?? ""
                let promiseTitle = data["promiseTitle"] as? String ?? ""
                let promiseDate = data["promiseDate"] as? Double ?? 0.0
                let destination = data["destination"] as? String ?? ""
                let participantIdArray = data["participantIdArray"] as? [String] ?? []
                let checkDoublePromise = data["checkDoublePromise"] as? Bool ?? false
                let locationIdArray = data["locationIdArray"] as? [String] ?? []
                
                let promise = Promise(
                    makingUserID: makingUserID,
                    promiseTitle: promiseTitle,
                    promiseDate: promiseDate,
                    destination: destination,
                    participantIdArray: participantIdArray,
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
    
    // MARK: - 약속 추가 함수
    /// 약속 추가 함수
    func addPromise(_ promise: Promise) {
        let newData: [String: Any] = [
            "promiseTitle": "\(promise.promiseTitle)",
            "promiseDate": "\(promise.promiseDate)",
            "destination": "\(promise.destination)",
            "participantIdArray": "\(promise.participantIdArray)"
        ]

        // 컬렉션에 새로운 문서를 추가합니다. 자동으로 고유한 문서 ID가 생성됩니다.
        dbRef.addDocument(data: newData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document successfully added")
            }
        }
    }
    // MARK: - 약속 수정 함수
    /// 약속 수정 함수
    func editPromise(_ promise: Promise) {
        let updatedData: [String: Any] = [
            "promiseTitle": "\(promise.promiseTitle)",
            "promiseDate": "\(promise.promiseDate)",
            "destination": "\(promise.destination)",
            "participantIdArray": "\(promise.participantIdArray)"
        ]
        
        dbRef.document(promise.id).updateData(updatedData) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    // MARK: - 약속 삭제 함수
    /// 약속 삭제 함수
    func deletePromise(_ promise: Promise) {
        dbRef.document(promise.id).delete { error in
            if let error = error {
                print("Error deleting document: \(error)")
            } else {
                print("Document successfully deleted")
            }
        }
    }
}
