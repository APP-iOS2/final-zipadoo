//
//  AddPlaceButtonCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit

struct AddPlaceButtonCell: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    var promiseLocation: PromiseLocation
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .shadow(radius: 15)
                .overlay {
                    VStack {
                        HStack {
                            Spacer()
                            Button {
                                isClickedPlace = false
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.white, .red)
                            }
                            .shadow(radius: 5)
                        }
                        .padding(.top, 25)
                        .padding(.trailing, 6)
                        
                        Spacer()
                        
                        Text(promiseLocation.address)
                        
                        Spacer()
                        
                        Button {
                            addLocationButton = true
                            print(promiseLocation.latitude)
                            print(promiseLocation.longitude)
                            print(promiseLocation.address)
                            dismiss()
                        } label: {
                            Text("장소 선택하기")
                                .frame(width: 270, height: 15)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 5))
                    }
                    .padding(.bottom, 30)
                }
        }
    }
}

#Preview {
    AddPlaceButtonCell(isClickedPlace: .constant(true), addLocationButton: .constant(false), promiseLocation: PromiseLocation(latitude: 0.0, longitude: 0.0, address: "서울시 강남구 압구정로 165"))
}
