//
//  AddPromisePlaceCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

struct AddPromisePlaceCell: View {
    @State private var mapViewSheet: Bool = false
    @State private var promiseLocation: PromiseLocation = PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "")
    @State var address = ""
    var locationStore: LocationStore = LocationStore()
    
    var body: some View {
        Rectangle().stroke(Color.gray, lineWidth: 0.5)
            .frame(width: 350, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay {
                HStack {
                    HStack {
                        Text("장소")
                            .font(.title2)
                            .padding(.trailing, 10)
                        
                        Divider()
                        
                        Text(promiseLocation.address)
                            .font(.callout)
                            .padding(.leading, 5)
                    }
                    .padding(.leading, 0)
                    
                    Spacer()
                    
                    NavigationLink {
//                        mapViewSheet.toggle()
                        MapView(mapViewSheet: $mapViewSheet, promiseLocation: $promiseLocation)
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 40)
                            
                            Text("검색하기")
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                }.padding()
            }
            .sheet(isPresented: $mapViewSheet, content: {
                MapView(mapViewSheet: $mapViewSheet, promiseLocation: $promiseLocation)
                    .presentationDetents([.height(900)])
            })
    }
}

#Preview {
    AddPromisePlaceCell()
}
