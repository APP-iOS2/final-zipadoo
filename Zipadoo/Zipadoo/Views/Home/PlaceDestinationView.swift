//
//  PlaceDestinationView.swift
//  Zipadoo
//
//  Created by Handoo Jeong on 2023/09/21.
//

import SwiftUI

struct PlaceDestinationView: View {
    @State private var showTitle = true
    let title: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Text(title)
                    .font(.callout)
                    .bold()
                    .padding(5)
                    .foregroundColor(.red)
                    .cornerRadius(10)
                
                Image(systemName: "person.circle")
                    .font(.title)
                    .foregroundColor(.red)
                
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.caption)
                    .foregroundColor(.red)
                    .offset(x: 0, y: -5)
            }
        }
        
    }
}

#Preview {
    PlaceDestinationView(title: "약속장소")
}
