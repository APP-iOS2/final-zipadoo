//
//  ZipadooWidgetLiveActivity.swift
//  ZipadooWidget
//
//  Created by 아라 on 10/4/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ZipadooWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct ZipadooWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ZipadooWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension ZipadooWidgetAttributes {
    fileprivate static var preview: ZipadooWidgetAttributes {
        ZipadooWidgetAttributes(name: "World")
    }
}

extension ZipadooWidgetAttributes.ContentState {
    fileprivate static var smiley: ZipadooWidgetAttributes.ContentState {
        ZipadooWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: ZipadooWidgetAttributes.ContentState {
         ZipadooWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: ZipadooWidgetAttributes.preview) {
   ZipadooWidgetLiveActivity()
} contentStates: {
    ZipadooWidgetAttributes.ContentState.smiley
    ZipadooWidgetAttributes.ContentState.starEyes
}
