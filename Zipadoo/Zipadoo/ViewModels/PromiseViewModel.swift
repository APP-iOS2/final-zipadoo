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
import WidgetKit

class PromiseViewModel: ObservableObject {

    @Published var isLoading: Bool = true
    
    /// 예정인 약속 저장
    @Published var fetchPromiseData: [Promise] = []
    /// 추적중인 약속 저장
    @Published var fetchTrackingPromiseData: [Promise] = []
    /// 지난 약속 저장
    @Published var fetchPastPromiseData: [Promise] = []
    // 저장될 변수
    @Published var id: String = ""
    @Published var promiseTitle: String = ""
    @Published var date = Date()
    @Published var destination: String = "" // 약속 장소 이름
    @Published var address = "" // 약속장소 주소
    @Published var coordXXX = 0.0 // 약속장소 위도
    @Published var coordYYY = 0.0 // 약속장소 경도
    /// 장소에 대한 정보 값
    @Published var promiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
    /// 지각비 변수 및 상수 값
    @Published var penalty: Int = 0

    /// 약속에 참여할 친구배열
    @Published var selectedFriends: [User] = []
    
    /// 지난약속 아래 페이지 수(올림)
    var pastPromisePage: Int {
        var result = Int(ceil(Double(fetchPastPromiseData.count) / Double(10)))
        // 페이지가 5보다 크다면 5페이지까지
        if result > 5 {
            result = 5
        }
        return result
    }
    /// 선택된 페이지네이션 숫자
    @Published var selectedPage: Int = 1 // 디폴트 1
    
    private let dbRef = Firestore.firestore().collection("Promise")
    
//    init() {
//        promiseViewModel = []
//    }
    
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
    func fetchData(userId: String) async throws {
        do {
            let snapshot = try await dbRef.getDocuments()

            var tempPromiseArray: [Promise] = []
            var tempPromiseTracking: [Promise] = []
            var tempPastPromise: [Promise] = []
            
            /// 현재 시각
            let currentDate = Date()
            
            for document in snapshot.documents {
                if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let promise = try? JSONDecoder().decode(Promise.self, from: jsonData) {
                    if promise.makingUserID == userId || promise.participantIdArray.contains(userId) {
                        /// 약속시간
                        let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
                        /// 약속시간에서 3시간 후 시각
                        let afterPromise = Calendar.current.date(byAdding: .hour, value: 3, to: promiseDate) ?? promiseDate // 3시간 뒤
                        /// 약속시간에서 30분 전
                        let beforePromise = Calendar.current.date(byAdding: .minute, value: -30, to: promiseDate) ?? promiseDate // 3시간 뒤
                        
                        if Calendar.current.dateComponents([.second], from: currentDate, to: beforePromise).second ?? 0 > 0 {
                            // 추적시간 아직 안됐을때
                            tempPromiseArray.append(promise)
                            
                        } else if Calendar.current.dateComponents([.second], from: currentDate, to: afterPromise).second ?? 0 > 0 {
                            // 추적중일떄
                            tempPromiseTracking.append(promise)
                        } else {
                            // 지난 약속
                            tempPastPromise.append(promise)
                        }
                    }
                }
                DispatchQueue.main.async {
                    // 오름차순 정렬
                    tempPromiseArray.sort(by: {$0.promiseDate < $1.promiseDate})
                    tempPromiseTracking.sort(by: {$0.promiseDate < $1.promiseDate})
                    // 내림차순 정렬
                    tempPastPromise.sort(by: {$0.promiseDate > $1.promiseDate})
                    
                    self.fetchPromiseData = tempPromiseArray
                    self.fetchTrackingPromiseData = tempPromiseTracking
                    
                    self.fetchPastPromiseData.removeAll() // 지난약속 다시 초기화
                    
                    // 지난약속이 50개 이상이면 fetchPastPromiseData에 50개까지 넣기
                    if tempPastPromise.count > 50 {
                        for i in 0 ..< 50 {
                            self.fetchPastPromiseData.append(tempPastPromise[i])
//                            print("\(i)")
                        }
                    } else {
                        self.fetchPastPromiseData = tempPastPromise
                    }
                    
                    self.addTodayPromisesToUserDefaults()

                    if let imminent = self.fetchTrackingPromiseData.first {
                        self.addSharingNotification(imminent: imminent)
                    } else if let imminent = self.fetchPromiseData.first {
                        self.addSharingNotification(imminent: imminent)
                    }
                    self.isLoading = false
                }
            }
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
           destination: destination,
           address: address,
           latitude: coordXXX,
           longitude: coordYYY,
           participantIdArray: [AuthStore.shared.currentUser?.id ?? " - no id - "] + selectedFriends.map { $0.id },
           checkDoublePromise: false, // 원하는 값으로 설정
           locationIdArray: [],
           penalty: penalty)
        
        do {
            // 친구도 동일하게 저장
            // locationIdArray에 친구Location객체 id저장
            for id in promise.participantIdArray {
                // Location객체 생성
                let friendLocation = Location(participantId: id, departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
                promise.locationIdArray.append(friendLocation.id)
                
                LocationStore.addLocationData(location: friendLocation) // 파베에 Location저장
            }
            
            try dbRef.document(promise.id)
                .setData(from: promise)
            // 약속 추가후 다시 패치
            if let loginUserID = AuthStore.shared.currentUser?.id {
                try await fetchData(userId: loginUserID)
            }
            
            id = ""
            promiseTitle = ""
            date = Date()
            destination = "" // 약속 장소 이름
            address = "" // 약속장소 주소
            coordXXX = 0.0 // 약속장소 위도
            coordYYY = 0.0 // 약속장소 경도
            /// 장소에 대한 정보 값
            promiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
            /// 선택된 친구 초기화
            selectedFriends = []
            /// 지각비 변수 및 상수 값
            penalty = 0

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
//    func editPromise(_ promise: Promise) {
//        let updatedData: [String: Any] = [
//            "participantIdArray": "\(promise.participantIdArray)"
//        ]
//        
//        dbRef.document(promise.id).updateData(updatedData) { error in
//            if let error = error {
//                print("Error updating document: \(error)")
//            } else {
//                print("Document successfully updated")
//            }
//        }
//    }
    
    // 나가기 버튼 구현을 위해 기존 함수 주석처리
    func exitPromise(_ promise: Promise, locationId: String) async throws {
        
        do {
            let firestore = Firestore.firestore()
            let promiseRef = firestore.collection("Promise").document(promise.id)
            
            let updateData: [String: Any] = [
                "participantIdArray": promise.participantIdArray,
                "locationIdArray": promise.locationIdArray
            ]
            
            try await LocationStore.deleteLocationData(locationId: locationId)
            
            try await promiseRef.updateData(updateData)
        } catch {
            print("약속 업데이트 실패: \(error)")
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
        // 다시패치
        if let loginUserID = AuthStore.shared.currentUser?.id {
            try await fetchData(userId: loginUserID)
        }
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
    
    func addTodayPromisesToUserDefaults() {
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local
        let encoder = JSONEncoder()
        
        // 위젯에 나타낼 데이터
        var widgetDatas: [WidgetData] = []
        
        let entryPromises = fetchTrackingPromiseData + fetchPromiseData
        
        for promise in entryPromises {
            let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
            let promiseDateComponents = calendar.dateComponents([.year, .month, .day], from: promiseDate)
            let todayComponents = calendar.dateComponents([.year, .month, .day], from: Date())
            
            if promiseDateComponents == todayComponents {
                let data = WidgetData(promiseID: promise.id, title: promise.promiseTitle, time: promise.promiseDate, place: promise.destination)
                widgetDatas.append(data)
            } else {
                // 오름차순 정렬인데 해당 약속이 오늘이 아니라면 이 후 약속은 볼 필요 없음
                break
            }
        }
        
        do {
            let encodedData = try encoder.encode(widgetDatas)
            
            UserDefaults.shared.set(encodedData, forKey: "todayPromises")
            
            WidgetCenter.shared.reloadTimelines(ofKind: "ZipadooWidget")
        } catch {
            print("Failed to encode Promise:", error)
            
        }
    }
}
