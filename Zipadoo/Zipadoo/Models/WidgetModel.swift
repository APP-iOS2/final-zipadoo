//
//  WidgetModel.swift
//  Zipadoo
//
//  Created by 아라 on 10/5/23.
//

import Foundation

struct WidgetData: Identifiable, Codable {
    var id = UUID().uuidString
    let title: String
    let time: Double
    let place: String
    var arrivalMember: Int
}
