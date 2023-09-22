//
//  AddPenaltyCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

struct AddPenaltyCell: View {
    @State var penelty: String = ""
    @State var peneltyChoose: Bool = false
    @State var peneltyChooseSheet: Bool = false
    
    var body: some View {
        Rectangle().stroke(Color.gray, lineWidth: 0.5)
            .frame(width: 350, height: 90, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .overlay {
                HStack {
                    
                    VStack(alignment: .leading) {
                        Text("지각")
                        Text("페널티")
                    }
                    .font(.title2)
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Spacer()
                        Text("\(penelty)")
                        Spacer()
                    }
                    .font(.callout)
                    
                    Spacer()
                    
                    Button {
                        peneltyChooseSheet.toggle()
                        peneltyChoose.toggle()
                        showPeneltyText()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .frame(width: 80, height: 60)
                            Text("선택하기")
                                .foregroundStyle(.white)
                        }
                    }
                    //                    .tint(.brown)
                    
                }.padding()
            }
            .sheet(isPresented: $peneltyChooseSheet, content: {
                Text("PeneltySheet")
            })
    }
    
    func showPeneltyText() {
        if peneltyChoose == true {
            penelty = "스타벅스 아메리카노 T"
        } else {
            penelty = ""
        }
    }
    
}

#Preview {
    AddPenaltyCell()
}
