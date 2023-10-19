//
//  AlertStore.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

class AlertStore: ObservableObject {
    @Published var isPresentedArrival: Bool = false
    @Published var arrivalMsgAlert = ArrivalMsgModel(name: "", profileImgString: "",
        rank: 0, arrivarDifference: 720.0, potato: 0)
}
