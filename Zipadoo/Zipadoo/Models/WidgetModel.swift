//
//  WidgetModel.swift
//  Zipadoo
//
//  Created by 아라 on 10/5/23.
//

import Foundation

struct Widget: Identifiable, Codable {
    var id = UUID().uuidString
    let title: String
    let time: String
    let place: String
    var arrivalMember: String
}
