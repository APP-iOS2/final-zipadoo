//
//  PromiseViewModel.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

final class PromiseViewModel: ObservableObject {
    @Published var fetchPromiseData: [Promise] = []
    // 저장될 변수
    @Published var id: String = ""
    @Published var promiseTitle: String = ""
    @Published var date = Date()
    @Published var destination: String = "" // 약속 장소 이름
    @Published var address = "" // 약속장소 주소
    @Published var coordX = 0.0 // 약속장소 위도
    @Published var coordY = 0.0 // 약속장소 경도
    /// 장소에 대한 정보 값
    @Published var promiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
    /// 지각비 변수 및 상수 값
    @Published var selectedValue: Int = 0
    
    /// 약속에 참여할 친구배열
    @Published var selectedFriends: [User] = []
    
    private let dbRef = Firestore.firestore().collection("Promise")
    
    init() {
        Task {
            try await fetchData()
        }
    }
    
    // MARK: - 약속 패치 함수
    /// 약속 패치 함수
    //    func fetchPromise() async throws {
    //        self.promiseViewModel.removeAll()
    //
    //        /*
    //         participantIdArray에 ID 값과 같은 사람들만 가져온다.
    //         guard let userID =
    //         */
    //
    //        do {
    //            let snapshot = try await dbRef.getDocuments()
    //
    //            for document in snapshot.documents {
    //                let data = document.data()
    //                print("Document data: \(data)")
    //
    //                // Firebase document 맵핑
    //                let id = data["id"] as? String ?? ""
    //                let makingUserID = data["makingUserID"] as? String ?? ""
    //                let promiseTitle = data["promiseTitle"] as? String ?? ""
    //                let promiseDate = data["promiseDate"] as? Double ?? 0.0
    //                let destination = data["destination"] as? String ?? ""
    //                let participantIdArray = data["participantIdArray"] as? [String] ?? []
    //                let checkDoublePromise = data["checkDoublePromise"] as? Bool ?? false
    //                let locationIdArray = data["locationIdArray"] as? [String] ?? []
    //
    //                let promise = Promise(
    //                    id: id,
    //                    makingUserID: makingUserID,
    //                    promiseTitle: promiseTitle,
    //                    promiseDate: promiseDate,
    //                    destination: destination,
    //                    participantIdArray: participantIdArray,
    //                    checkDoublePromise: checkDoublePromise,
    //                    locationIdArray: locationIdArray
    //                )
    //
    //                // promiseViewModel에 추가
    //                self.promiseViewModel.append(promise)
    //
    //            }
    //        } catch {
    //            print("Error getting documents: \(error)")
    //        }
    //    }
    @MainActor
    func fetchData() async throws {
        do {
            let snapshot = try await dbRef.getDocuments()
            
            var temp: [Promise] = []
            
            for document in snapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let promise = try? JSONDecoder().decode(Promise.self, from: jsonData) {
                    
                        temp.append(promise)   
                }
            }
            self.fetchPromiseData = temp
            
        } catch {
            print("fetchPromiseData failed")
        }
    }
    /*
     do {
         // 로그인한 유저 id 못 받아오면 return
         guard let loginUserID = AuthStore.shared.currentUser?.id else {
             return
         }
         let snapshot = try await dbRef.getDocuments()

         var temp: [Promise] = []
         
         for document in snapshot.documents {
             if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                let promise = try? JSONDecoder().decode(Promise.self, from: jsonData) {
                 
                 // 내가 만든 또는 참여하는 약속만 배열에 넣기
                 if loginUserID == promise.makingUserID || promise.participantIdArray.contains(loginUserID) {
                     temp.append(promise)
                 }
             }
         }
         self.fetchPromiseData = temp

     } catch {
         print("fetchPromiseData failed")
     }
     */
    
    // PromiseId로 Promise객체 가져오기
    static func fetchPromise(promiseId: String) async throws -> Promise {
        let snapshot = try await Firestore.firestore().collection("Promise").document(promiseId).getDocument()
        
        let promise = try snapshot.data(as: Promise.self)
        return promise

    }
    
    // MARK: - 약속 추가 함수
    /// 약속 추가 함수
    //    func addPromise(_ promise: Promise) {
    //        let newData: [String: Any] = [
    //            "id": "\(promise.id)",
    //            "makingUserID": "\(promise.makingUserID)",
    //            "promiseTitle": "\(promise.promiseTitle)",
    //            "promiseDate": "\(promise.promiseDate)",
    //            "destination": "\(promise.destination)",
    //            "participantIdArray": "\(promise.participantIdArray)"
    //        ]
    //
    //        dbRef.addDocument(data: newData) { error in
    //            if let error = error {
    //                print("Error adding document: \(error)")
    //            } else {
    //                print("Document successfully added")
    //            }
    //        }
    //    }
    
    @MainActor
    func addPromiseData() async throws {
        // Promise객체 생성
        var promise = Promise(
           id: UUID().uuidString,
           makingUserID: AuthStore.shared.currentUser?.id ?? "not ID",
           promiseTitle: promiseTitle,
           promiseDate: date.timeIntervalSince1970, // 날짜 및 시간을 TimeInterval로 변환
           destination: promiseLocation.destination,
           address: promiseLocation.address,
           latitude: promiseLocation.latitude,
           longitude: promiseLocation.longitude,
           participantIdArray: selectedFriends.map { $0.id },
           checkDoublePromise: false, // 원하는 값으로 설정
           locationIdArray: [])
        
        do {
            // locationIdArray에 친구Location객체 id저장
            for id in promise.participantIdArray {
                // Location객체 생성
                let friendLocation = Location(participantId: id, departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
                promise.locationIdArray.append(friendLocation.id) // promise.locationIdArray에 저장
                
                LocationStore.addLocationData(location: friendLocation) // 파베에 Location저장
            }
        
            try dbRef.document(promise.id)
                .setData(from: promise)
            // 약속 추가후 다시 패치
            try await fetchData()
            
            id = ""
            promiseTitle = ""
            date = Date()
            destination = "" // 약속 장소 이름
            address = "" // 약속장소 주소
            coordX = 0.0 // 약속장소 위도
            coordY = 0.0 // 약속장소 경도
            /// 장소에 대한 정보 값
            promiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
            /// 지각비 변수 및 상수 값
            selectedValue = 0
    
        } catch {
            print("약속 등록")
        }
    }
    
    // 아래 형식으로 변경
    //    func addLocationData(location: Location) {
    //        do {
    //            try dbRef.collection("Location").document(location.id)
    //                .setData(from: location)
    //        } catch {
    //            print("location 등록 실패")
    //        }
    //    }
    
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
    //    func deletePromise(_ promise: Promise) {
    //        dbRef.document(promise.id).delete { error in
    //            if let error = error {
    //                print("Error deleting document: \(error)")
    //            } else {
    //                print("Document successfully deleted")
    //            }
    //        }
    //    }
    
    func deletePromiseData(promiseId: String, locationIdArray: [String]) async throws {
        
        // 연결된 Location 먼저 삭제
        for locationId in locationIdArray {
            try await LocationStore.deleteLocationData(locationId: locationId)
        }
        try await dbRef.document(promiseId).delete()
        
    }
}
