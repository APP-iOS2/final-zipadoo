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

class LocationStore: ObservableObject {
    @Published var locationDatas: [Location] = []
    let dbRef = Firestore.firestore()
    
    func fetchData(participantIdArray: [String]) {
        dbRef.collection("Location").getDocuments { (snapshot, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }
            var temp: [Location] = []
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    if let jsonData = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                       let locationData = try? JSONDecoder().decode(Location.self, from: jsonData) {
                        if participantIdArray.contains(locationData.participantId) {
                            temp.append(locationData)
                        }
                    }
                }
                self.locationDatas = temp
                print(self.locationDatas)
            }
        }
    }
    
    func addLocationData(location: Location) {
        do {
            try dbRef.collection("Location").document(location.id)
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
    
    func deleteLocationData(locationId: String) {
        dbRef.collection("Location").document(locationId).delete()
    }
}
