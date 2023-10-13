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
    
    static func addLocationData(location: Location) {
        do {
            try Firestore.firestore().collection("Location").document(location.id)
                .setData(from: location)
        } catch {
            print("location 등록 실패")
        }
    }
    
    func updateDeparture(locationId: String, newValue departure: String) {
        let updateData: [String: Any] = ["departure": departure]
        dbRef.collection("Location").document(locationId).updateData(updateData)
    }
    
    func updateCurrentLocation(locationId: String, newValue currentLocation: String) {
        let updateData: [String: Any] = ["currentLocation": currentLocation]
        dbRef.collection("Location").document(locationId).updateData(updateData)
    }
    
    func updateArriveTime(locationId: String, newValue arriveTime: Double) {
        let updateData: [String: Any] = ["arriveTime": arriveTime]
        dbRef.collection("Location").document(locationId).updateData(updateData)
    }
    
    static func deleteLocationData(locationId: String) {
        Firestore.firestore().collection("Location").document(locationId).delete()
    }
}
