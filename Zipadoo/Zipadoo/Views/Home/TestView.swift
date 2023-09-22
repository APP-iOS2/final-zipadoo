//
//  TestView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/21.
//

import SwiftUI

struct TestView: View {
    var body: some View {
        NavigationStack{
            NavigationLink(destination: MakePromiseView()) {
                Text("약속 만들기")
            }
        }
    }
}

#Preview {
    TestView()
}
