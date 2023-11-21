//
//  LocationStore.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/22.
//

import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation

/// Location마다의 참여자정보와 Location정보를 한꺼번에 저장하기 위한 임의의 구조체
struct LocationAndParticipant: Identifiable {
    var id = UUID().uuidString
    /// Location객체
    var location: Location
    var nickname: String
    var imageString: String
    /// 랜덤 두더지 이미지
    var moleImageString: String
    /// 유저 두더지 드릴 이미지
    var moleDrillImageString: String {
        return "\(moleImageString)_1"
    }
    /// 더미데이터
    static let dummyData1: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy1", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.48047306060714, currentLongitude: 126.95138412144169), nickname: "더미1", imageString: "", moleImageString: "doo1")
    static let dummyData2: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy2", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.48516705133686, currentLongitude: 127.01723145026864), nickname: "더미2", imageString: "", moleImageString: "doo2")
    static let dummyData3: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy3", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.441054579994564, currentLongitude: 127.00673485084162), nickname: "더미3", imageString: "", moleImageString: "doo3")
    static let dummyData4: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy4", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.47694972793077, currentLongitude: 126.98195644152227), nickname: "더미4", imageString: "", moleImageString: "doo4")
    static let dummyData5: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy1", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.38047306060714, currentLongitude: 126.85138412144169), nickname: "더미5", imageString: "", moleImageString: "doo5")
    static let dummyData6: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy2", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.28516705133686, currentLongitude: 127.71723145026864), nickname: "더미6", imageString: "", moleImageString: "doo6")
    static let dummyData7: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy3", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.141054579994564, currentLongitude: 127.60673485084162), nickname: "더미7", imageString: "", moleImageString: "doo7")
    static let dummyData8: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy4", departureLatitude: 0, departureLongitude: 0, currentLatitude: 37.059858093439664, currentLongitude: 126.5041804752457), nickname: "더미8", imageString: "", moleImageString: "doo8")
    static let dummyData9: LocationAndParticipant = LocationAndParticipant(location: Location(participantId: "dummy4", departureLatitude: 0, departureLongitude: 0, currentLatitude: 36.459858093439664, currentLongitude: 126.4041804752457), nickname: "더미9", imageString: "", moleImageString: "doo9")
}

class LocationStore: ObservableObject {
    /// 사용자 Location객체
    @Published var myLocation: Location = Location(participantId: "", departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
    /// 참여자들의 Location
    @Published var locationDatas: [Location] = []
    /// 참여자들의 Location과 닉네임을 저장
    @Published var locationParticipantDatas: [LocationAndParticipant] = []
    
    @Published var locationParticipantDatasDummy: [LocationAndParticipant] = [LocationAndParticipant.dummyData2, LocationAndParticipant.dummyData3, LocationAndParticipant.dummyData4, LocationAndParticipant.dummyData5, LocationAndParticipant.dummyData6, LocationAndParticipant.dummyData7, LocationAndParticipant.dummyData8, LocationAndParticipant.dummyData9]
    /// 사용자의 id
    var myid: String = AuthStore.shared.currentUser?.id ?? ""
    /*
    /// 사용자의 LocationId
    var myLocationId: String = ""
    */
    let dbRef = Firestore.firestore()
    
//    init() {
//        myLocation = Location(participantId: myid, departureLatitude: 0, departureLongitude: 0, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
//        print("myLocation 초기화 완료: \(myLocation)")
//    }
    init() {
        myLocationFetch()
    }
    ///
    func myLocationFetch() {
        // UserDefaults에서 데이터 가져오기
        do {
            if let data = UserDefaults.standard.object(forKey: "myLocationData") as? Data {
                myLocation = try
                JSONDecoder().decode(Location.self, from: data)
            }
        } catch {
            print("UserDefaults로 부터 데이터 가져오기 실패")
        }
    }
    // UserDefaults에 시작위치값 저장
    func updateDeparture(newLatitude: Double, newLongtitude: Double) {
        myLocation.participantId = AuthStore.shared.currentUser?.id ?? ""
        myLocation.departureLatitude = newLatitude
        myLocation.departureLongitude = newLongtitude
        print("변경후 myLocation: \(myLocation)")
        do {
            let data: Data = try JSONEncoder().encode(myLocation)
            UserDefaults.standard.set(data, forKey: "myLocationData")
        } catch {
            print("JSON 생성 후 UserDefaults 실패")
        }
    }
    
    /// Promise.locationIdArray로 Location정보가져오기
    @MainActor
    func fetchData(locationIdArray: [String]) async throws {
        if let myid = AuthStore.shared.currentUser?.id {
            do {
                var temp: [Location] = []
                var locationParticipantTemp: [LocationAndParticipant] = []
                
                for locationId in locationIdArray {
                    let snapshot = try await dbRef.collection("Location").document(locationId).getDocument()
                    let locationData = try snapshot.data(as: Location.self)
                    /// locationData로 가져온 참여자의 User객체
                    let userData = try await UserStore.fetchUser(userId: locationData.participantId)
                    /*
                    // 닉네임 가져오기
                    let nickname = try await fetchUserNickname(participantId: locationData.participantId)
                    // 이미지 가져오기
                    let imageString = try await fetchUserImageString(participantId: locationData.participantId)
                    // 이미지 가져오기
                    let moleImageString = try await fetchUserMoleImageString(participantId: locationData.participantId)
                     */
                    // 사용자의 Locationd일때
                    if locationData.participantId == myid {
//                        myLocationId = locationData.id
//                        myLocation.id = myLocationId
                        myLocation.id = locationData.id
                    }
                    // 자기자신을 포함하여 저장
                    locationParticipantTemp.append(LocationAndParticipant(location: locationData, nickname: userData?.nickName ?? " - ", imageString: userData?.profileImageString ?? " - ", moleImageString: userData?.moleImageString ?? " - "))

                    temp.append(locationData)
                }
                
                DispatchQueue.main.async {
                    self.locationDatas = temp
                    self.locationParticipantDatas = locationParticipantTemp
                }
//                print(self.locationDatas)
            } catch {
                print("fetch locationData failed")
            }
        } else {
            print("LocationStore에서 유저 id 못가져옴")
        }
    }
    
    /// 도착했을 때 순위계산
    func calculateRank() -> Int {
        var count: Int = 0
        for locationData in locationDatas {
            // 얖에 이미 도착한 사람이 있으면 count 1증가
            if locationData.arriveTime > 0 {
                count += 1
            }
        }
        return count+1
    }
    /* 삭제예정
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
    
    /// locationData의 participantId로 유저의 이미지만 가져오기
    func fetchUserImageString(participantId: String) async throws -> String {
        var imageString = " - "
        do {
            imageString = try await UserStore.fetchUser(userId: participantId)?.profileImageString ?? " - "
            
        } catch {
            print("fetchUserImageString failed")
        }
        return imageString
    }
    
    /// locationData의 participantId로 유저의 두더지 이미지만 가져오기
    func fetchUserMoleImageString(participantId: String) async throws -> String {
        var moleImageString = " - "
        do {
            moleImageString = try await UserStore.fetchUser(userId: participantId)?.moleImageString ?? " - "
            
        } catch {
            print("fetchUserImageString failed")
        }
        return moleImageString
    }
    */
    /// Promise 저장시 Location저장
    static func addLocationData(location: Location) {
        do {
            try Firestore.firestore().collection("Location").document(location.id)
                .setData(from: location)
        } catch {
            print("location 등록 실패")
        }
    }

    /* func updateDeparture(locationId: String, newLatitude: Double, newLongtitude: Double) {
        let updateData1: [String: Any] = ["departureLatitude": newLatitude]
        let updateData2: [String: Any] = ["departureLongitude": newLongtitude]
        dbRef.collection("Location").document(locationId).updateData(updateData1)
        dbRef.collection("Location").document(locationId).updateData(updateData2)
    } */
    
    func updateCurrentLocation(locationId: String, newLatitude: Double, newLongtitude: Double) {
        let updateData1: [String: Any] = ["currentLatitude": newLatitude]
        let updateData2: [String: Any] = ["currentLongitude": newLongtitude]
        dbRef.collection("Location").document(locationId).updateData(updateData1)
        dbRef.collection("Location").document(locationId).updateData(updateData2)
    }
    // Rank 추가하기
    func updateArriveTime(locationId: String, arriveTime: Double, rank: Int) {
        let updateData: [String: Any] = ["arriveTime": arriveTime]
        dbRef.collection("Location").document(locationId).updateData(updateData)
        let updateData2: [String: Any] = ["rank": rank]
        dbRef.collection("Location").document(locationId).updateData(updateData2)
    }
    
    static func deleteLocationData(locationId: String) async throws {
        do {
            try await Firestore.firestore().collection("Location").document(locationId).delete()
        } catch {
            print("deleteLocationData failed")
        }
    }
    
    /// 받아온 locationAndParticipants 배열을 순위에 따라 정렬
    func sortResult(resultArray: [LocationAndParticipant]) -> [LocationAndParticipant] {
        let arriveArray = resultArray.filter({$0.location.rank != 0})
        let tempArray: [LocationAndParticipant] = arriveArray.sorted(by: {$0.location.rank < $1.location.rank})
        let notArriveArray = resultArray.filter({$0.location.rank == 0})
        return tempArray + notArriveArray // 빨리도착한 사람 순으로 정렬
    }
}
