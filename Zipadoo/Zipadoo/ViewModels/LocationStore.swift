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
}
