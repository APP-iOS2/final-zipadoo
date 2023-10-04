//
//  InfoEntry.swift
//  Zipadoo
//
//  Created by 아라 on 10/4/23.
//

import WidgetKit

protocol ZipadooEntry: TimelineEntry {
    var date: Date { get }
}

struct InfoEntry: ZipadooEntry {
    let date: Date
    let title: String
    let destination: String
    let time: String
}

struct ArrivalStatusEntry: ZipadooEntry {
    let date: Date
    let name: String
    let percentage: Double
}
