//
//  AddPenaltyCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

//import SwiftUI
//
//// MARK: - 사용 안함
//struct AddPenaltyCell: View {
//    @State var peneltyInt: String = ""
//    @State var peneltyChoose: Bool = false
//    @State var peneltyChooseSheet: Bool = false
//    
//    var body: some View {
//        Rectangle().stroke(Color.gray, lineWidth: 0.5)
//            .frame(width: 350, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .overlay {
//                HStack {
//                    
//                    VStack(alignment: .leading) {
//                        Text("벌금")
//                    }
//                    .font(.title2)
//                    
//                    Spacer()
//                    
//                    Spacer()
//                    TextField("5,000", text: $peneltyInt, axis: .horizontal)
//                        .frame(width: 220, height: 100)
//                        .textFieldStyle(.roundedBorder)
//                        .keyboardType(.numberPad)
//                        .multilineTextAlignment(.trailing)
//                    
//                    Text("₩")
//                }.padding()
//            }
//    }
//}
//
//#Preview {
//    AddPenaltyCell()
//}
