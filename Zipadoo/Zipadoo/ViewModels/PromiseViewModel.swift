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

@MainActor
class PromiseViewModel: ObservableObject {
    @Published var promiseViewModel: [Promise]
    @Published var isLoading: Bool = true
    
    private let dbRef = Firestore.firestore().collection("Promise")
    
    init() {
        promiseViewModel = []
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
    
    func fetchData(userId: String) async throws {
        self.isLoading = true
        do {
            dbRef.getDocuments { (snapshot, error) in
                guard error == nil else {
                    print("오류: \(error!)")
                    self.isLoading = false
                    return
                }
                var temp: [Promise] = []
                if let snapshot = snapshot {
                    for document in snapshot.documents {
                        if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                           let promise = try? JSONDecoder().decode(Promise.self, from: jsonData) {
                            if promise.makingUserID == userId || promise.participantIdArray.contains(userId) {
                                temp.append(promise)
                            }
                        }
                    }
                    self.promiseViewModel = temp
                    if let imminent = self.promiseViewModel.first {
                        self.addSharingNotification(imminent: imminent)
                    }
                    print(self.promiseViewModel)
                    self.isLoading = false
                }
            }
        }
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
    
    func addPromiseData(promise: Promise) {
        do {
            try dbRef.document(promise.id)
                .setData(from: promise)
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
    
    func deletePromiseData(promiseId: String) {
        dbRef.document(promiseId).delete()
    }
    
    /// 약속 30분 전 위치 공유 알림 등록 메서드
    func addSharingNotification(imminent: Promise) {
        let notificationCenter = UNUserNotificationCenter.current()

        // 가장 가까운 약속 날짜
        let imminentDate = Date(timeIntervalSince1970: imminent.promiseDate)
        // 약속시간 30분 계산
        let triggerDate = Calendar.current.date(byAdding: .minute, value: -30, to: imminentDate)!
        // 계산 후 시간을 local에 맞게 수정
        let localTriggerDate = Calendar.current.date(bySettingHour: Calendar.current.component(.hour, from: triggerDate),
                                                     minute: Calendar.current.component(.minute, from: triggerDate),
                                                     second: 0,
                                                     of: Date())!
        // 알림이 울릴 시간 설정. 초단위는 0으로
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: localTriggerDate)
        dateComponents.second = 0
        
        // 알림 메세지 설정
        let content = UNMutableNotificationContent()
        content.title = "\(imminent.promiseTitle) 30분 전입니다"
        content.body = "친구들의 위치 현황을 확인해보세요!"

        // 알림이 울릴 trigger 설정
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)

        // Notification에 등록할 identifier 설정
        let requestIdentifier = "LocationSharing"
        
        // 등록
        let request = UNNotificationRequest(identifier: requestIdentifier,
                                            content: content,
                                            trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if error != nil {
                print("에러 \(requestIdentifier)")
            }
        }
        
        // 현재 등록된 알림 확인하는 코드
//        notificationCenter.getPendingNotificationRequests { (requests) in
//            for request in requests {
//                print("\(request.identifier) will be delivered at \(request.trigger)")
//            }
//        }
    }
}
