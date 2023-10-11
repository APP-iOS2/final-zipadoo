//
//  ZipadooWidgetBundle.swift
//  ZipadooWidget
//
//  Created by 아라 on 10/4/23.
//

import WidgetKit
import SwiftUI

@main
struct ZipadooWidgetBundle: WidgetBundle {
    var body: some Widget {
        ZipadooWidget()
        ZipadooWidgetLiveActivity()
    }
}
