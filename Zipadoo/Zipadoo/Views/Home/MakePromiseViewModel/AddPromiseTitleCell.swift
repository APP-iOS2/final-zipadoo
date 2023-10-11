//
//  MakePromiseTitleCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

//import SwiftUI
//
//// MARK: - 사용 안함
//struct AddPromiseTitleCell: View {
//    @State private var promiseTitle: String = ""
//    
//    var body: some View {
//        Rectangle().stroke(Color.gray, lineWidth: 0.5)
//            .frame(width: 350, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .overlay {
//                VStack {
//                    Spacer()
//                    HStack {
//                        Text("약속 이름")
//                            .font(.title2)
//                        Spacer()
//                    }.padding(.leading, 0)
//                    
//                    Spacer()
//                    
//                    VStack {
//                        TextField("입력하세요", text: $promiseTitle, axis: .horizontal)
//                            .font(.body).fontWeight(.thin)
//                        
//                        Divider()
//                            .frame(width: 320)
//                            .overlay {
//                                Color.gray
//                            }
//                    }
//                }.padding()
//            }
//    }
//}
//
//#Preview {
//    AddPromiseTitleCell()
//}
