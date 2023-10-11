//
//  AddDateCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

//import SwiftUI
//
//// MARK: - 사용 안함
//struct AddDateCell: View {
//    @State private var date = Date()
//    private let today = Calendar.current.startOfDay(for: Date())
//    
//    var body: some View {
//        Rectangle().stroke(Color.gray, lineWidth: 0.5)
//            .frame(width: 350, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
//            .overlay {
//                HStack {
//                    DatePicker("날짜/시간", selection: $date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
//                        .datePickerStyle(.compact)
//                        .font(.title2)
//                }.padding()
//            }
//    }
//}
//
//#Preview {
//    AddDateCell()
//}
