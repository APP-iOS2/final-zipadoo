//
//  AddPromisePlaceCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

struct AddPromisePlaceCell: View {
    @State private var mapViewSheet: Bool = false
    var body: some View {
        Rectangle().stroke(Color.gray, lineWidth: 0.5)
            .frame(width: 350, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay {
                HStack {
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("장소")
                            .font(.title2)
                        Spacer()
                        Text("서울특별시 마포구 양화로 지하160")
                            .font(.callout)
                    }
                    .padding(.leading, -15)
                    
                    Spacer()
                    
                    Button {
                        mapViewSheet.toggle()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 60)
                            
                            Text("검색하기")
                                .foregroundStyle(Color.white)
                        }
                    }
                    
                }.padding()
            }
            .sheet(isPresented: $mapViewSheet, content: {
                Text("MapView")
            })
    }
}

#Preview {
    AddPromisePlaceCell()
}
