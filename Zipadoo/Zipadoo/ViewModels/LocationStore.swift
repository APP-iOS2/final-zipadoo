//
//  LocationStore.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/22.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

struct LocationAndParticipant: Identifiable {
    var id = UUID().uuidString
    var location: Location
    var nickname: String
}

class LocationStore: ObservableObject {
    /// 참여자들의 Location 저장
    @Published var locationDatas: [Location] = []
    /// 참여자들의 Location과 닉네임을 저장
    @Published var locationParticipantDatas: [LocationAndParticipant] = []
    
    let dbRef = Firestore.firestore()
    
    /// locationIdArray로 Location배열 패치
       @MainActor
       func fetchData(locationIdArray: [String]) async throws {
           do {
//               locationDatas.removeAll()
//               locationParticipantDatas.removeAll()
               
               var temp: [Location] = []
               var locationParticipantTemp: [LocationAndParticipant] = []
               
               for locationId in locationIdArray {
                   let snapshot = try await dbRef.collection("Location").document(locationId).getDocument()
                   let locationData = try snapshot.data(as: Location.self)
                   
                   // 닉네임 가져오기
                   let nickname = try await fetchUserNickname(participantId: locationData.participantId)
                   
                   temp.append(locationData)
                   
                   // LocationAndNickname으로도 저장
                   locationParticipantTemp.append(LocationAndParticipant(location: locationData, nickname: nickname))
               }
               
               DispatchQueue.main.async {
                   self.locationDatas = temp
                   self.locationParticipantDatas = locationParticipantTemp
               }
           
//               print(self.locationDatas)
               
           } catch {
               print("fetch locationData failed")
           }
       }
    
    /// locationData의 participantId로 유저의 닉네임만 가져오기
    func fetchUserNickname(participantId: String) async throws -> String {
        var nickname = " - "
        do {
            nickname = try await UserStore.fetchUser(userId: participantId)?.nickName ?? " - "
            
        } catch {
            print("fetchUserNickname failed")
        }
        return nickname
    }
    
    static func addLocationData(location: Location) {
        do {
            try Firestore.firestore().collection("Location").document(location.id)
                .setData(from: location)
        } catch {
            print("location 등록 실패")
        }
    }
    // 아마 시작점 변경은 안쓰지 않을까
    func updateDeparture(locationId: String, newLatitude: Double, newLongtitude: Double) {
        let updateData1: [String: Any] = ["departureLatitude": newLatitude]
        let updateData2: [String: Any] = ["departureLongitude": newLongtitude]
        dbRef.collection("Location").document(locationId).updateData(updateData1)
        dbRef.collection("Location").document(locationId).updateData(updateData2)
    }

    func updateCurrentLocation(locationId: String, newLatitude: Double, newLongtitude: Double) {
        let updateData1: [String: Any] = ["currentLatitude": newLatitude]
        let updateData2: [String: Any] = ["currentLongitude": newLongtitude]
        dbRef.collection("Location").document(locationId).updateData(updateData1)
        dbRef.collection("Location").document(locationId).updateData(updateData2)
    }
    
    func updateArriveTime(locationId: String, newValue arriveTime: Double) {
        let updateData: [String: Any] = ["arriveTime": arriveTime]
        dbRef.collection("Location").document(locationId).updateData(updateData)
    }
    
    static func deleteLocationData(locationId: String) async throws {
        do {
            try await Firestore.firestore().collection("Location").document(locationId).delete()
        } catch {
            print("deleteLocationData failed")
        }
    }
}
