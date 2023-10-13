//
//  AddPromisePlaceCell.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/22.
//

import SwiftUI

// MARK: - 사용 안함
//struct AddPromisePlaceCell: View {
////    @State private var mapViewSheet: Bool = false
//    @State private var promiseLocation: PromiseLocation = PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
//    @State var address = ""
//    @State var isClickedPlace: Bool = false
//    @State var addLocationButton: Bool = false
//    var addLocationStore: AddLocationStore = AddLocationStore()
//        
//    var body: some View {
//        Rectangle().stroke(Color.gray, lineWidth: 0.5)
//            .frame(width: 350, height: 70, alignment: .center)
//            .overlay {
//                HStack {
//                    HStack {
//                        Text("장소")
//                            .font(.title2)
//                            .padding(.trailing, 10)
//                        
//                        Divider()
//                        
//                        Text(promiseLocation.address)
//                            .font(.callout)
//                            .padding(.leading, 5)
//                    }
//                    .padding(.leading, 0)
//                    
//                    Spacer()
//                    
//                    NavigationLink {
//                        AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address promiseLocation: $promiseLocation)
//                    } label: {
//                        ZStack {
//                            RoundedRectangle(cornerRadius: 10)
//                                .frame(width: 80, height: 40)
//                            
//                            Text("검색하기")
//                                .foregroundStyle(Color.white)
//                        }
//                    }
//                    
//                }.padding()
//            }
////            .sheet(isPresented: $mapViewSheet, content: {
////                MapView(mapViewSheet: $mapViewSheet, promiseLocation: $promiseLocation)                    .presentationDetents([.height(900)])
////            })
//    }
//}
//
//#Preview {
//    NavigationStack {
//        AddPromisePlaceCell()
//    }
//}
