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
        let snapshot = try await Firestore.firestore().collection("Promise").document(promiseId).getDocument()
        
        let promise = try snapshot.data(as: Promise.self)
        self.widgetPromise = promise
        self.isShowingDetailForWidget = true
    }
}
