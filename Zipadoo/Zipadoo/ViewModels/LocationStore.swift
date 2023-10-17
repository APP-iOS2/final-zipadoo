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
    var imageString: String
}

class LocationStore: ObservableObject {
//    let gpsStore: GPSStore = GPSStore()
    /// 나의 Location 저장
    @Published var myLocation: Location = Location(participantId: "", departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
    /// 참여자들의 Location 저장
    @Published var locationDatas: [Location] = []
    /// 참여자들의 Location과 닉네임을 저장
    @Published var locationParticipantDatas: [LocationAndParticipant] = []
    
    var myid: String = AuthStore.shared.currentUser?.id ?? ""
    
    var myLocationId: String = ""
    
    let dbRef = Firestore.firestore()
    
//    init() {
//        myLocation = Location(participantId: myid, departureLatitude: 0, departureLongitude: 0, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
//        print("myLocation 초기화 완료: \(myLocation)")
//    }
    
    /// locationIdArray로 Location배열 패치
    @MainActor
    func fetchData(locationIdArray: [String]) async throws {
        if let myid = AuthStore.shared.currentUser?.id {
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
                    // 이미지 가져오기
                    let imageString = try await fetchUserImageString(participantId: locationData.participantId)
                    // myLocation에 자기 데이터 저장
                    if locationData.participantId == myid {
                        myLocationId = locationData.id
                        myLocation.id = myLocationId
                    }
                    // LocationAndNickname으로도 나 포함하여 다 저장
                    locationParticipantTemp.append(LocationAndParticipant(location: locationData, nickname: nickname, imageString: imageString))
                    // locatioonDatas는 나 포함하여 다 저장
                    temp.append(locationData)
                }
                
                DispatchQueue.main.async {
                    self.locationDatas = temp
                    self.locationParticipantDatas = locationParticipantTemp
                }
                
                print(self.locationDatas)
                
            } catch {
                print("fetch locationData failed")
            }
        } else {
            print("LocationStore에서 유저 id 못가져옴")
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
    
    /// locationData의 participantId로 유저의 닉네임만 가져오기
    func fetchUserImageString(participantId: String) async throws -> String {
        var imageString = " - "
        do {
            imageString = try await UserStore.fetchUser(userId: participantId)?.profileImageString ?? " - "
            
        } catch {
            print("fetchUserImageString failed")
        }
        return imageString
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
