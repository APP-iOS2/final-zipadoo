//
//  ModelTestView.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/22.
//

import SwiftUI

struct ModelTestView: View {
    
    @ObservedObject var promiseViewModel: PromiseViewModel
    @State private var makingUserID: String = ""
    @State private var promiseTitle: String = ""
    @State private var promiseDate: Double = 0.0
    @State private var destination: String = ""
    @State private var participantIdArray: [String] = []
    @State private var checkDoublePromise: Bool = false
    @State private var locationIdArray : [String]
    
    var body: some View {
        VStack {
            TextField("", text: $makingUserID)
            TextField("", text: $promiseTitle)
            TextField("", text: $destination)
            TextField("", text: $makingUserID)
            TextField("", text: $makingUserID)
            TextField("", text: $makingUserID)
            TextField("", text: $makingUserID)
            Text("")
            Text("Hello, World!")
        }
    }
}

#Preview {
    ModelTestView(promiseViewModel: .init())
}
