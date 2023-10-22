//
//  WidgetStore.swift
//  Zipadoo
//
//  Created by 아라 on 10/20/23.
//

import Foundation
import FirebaseFirestore

class WidgetStore: ObservableObject {
    @Published var widgetPromiseID: String?
    @Published var widgetPromise: Promise?
    @Published var isShowingDetailForWidget: Bool = false
    
    func fetchPromise(promiseId: String) async throws {
        do {
            let snapshot = try await Firestore.firestore().collection("Promise").document(promiseId).getDocument()
            
            let promise = try snapshot.data(as: Promise.self)
            DispatchQueue.main.async {
                self.widgetPromise = promise
                self.isShowingDetailForWidget = true
            }
        } catch {
            print("widget promise fail")
        }
    }
}
