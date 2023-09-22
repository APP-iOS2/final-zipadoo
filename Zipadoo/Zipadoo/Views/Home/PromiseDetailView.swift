//
//  PromiseDetailView.swift
//  Zipadoo
//
//  Created by 아라 on 2023/09/21.
//

import SwiftUI

struct PromiseDetailView: View {
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("ADF")
                
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    zipadooToolbarView
                }
            }
        }
    }
    
    private var zipadooToolbarView: some View {
        HStack {
            Button {
                print(Date().timeIntervalSince1970)
            } label: {
                Image(systemName: "square.and.arrow.up")
            }
            Button {
                
            } label: {
                Image(systemName: "ellipsis")
            }
        }
        .foregroundColor(.secondary)
    }
}

#Preview {
    PromiseDetailView()
}
