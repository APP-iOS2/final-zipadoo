//
//  ShareView.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/22.
//

import SwiftUI
import UIKit
import AppsFlyerLib

struct ActivityViewController: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        // activityType, completed, returnedItems, error 미사용으로 _ 사용
        controller.completionWithItemsHandler = { (_, _, _, _) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }
    
    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: UIViewControllerRepresentableContext<ActivityViewController>
    ) {}
}
