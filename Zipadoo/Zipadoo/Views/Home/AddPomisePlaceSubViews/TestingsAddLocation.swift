//
//  TestingsAddLocation.swift
//  Zipadoo
//
//  Created by 김상규 on 10/12/23.
//

import SwiftUI

struct TestingsAddLocation: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordX: Double
    @Binding var coordY: Double
    
    @Binding var placeOfText: String
    @Binding var selectedPlace: Bool
    @Binding var isClickedPlace: Bool
    @Binding var promiseLocation: PromiseLocation
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.white)
                .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                .shadow(radius: 15)
                .overlay {
                    VStack {
                        Spacer()
                        if selectedPlace == true {
                            TextField(address, text: $placeOfText)
                                .textFieldStyle(.roundedBorder)
                                .padding(.horizontal)
                                .frame(height: 30)
                        } else {
                            Text("약속 장소를 선택해 주세요")
                                .font(.title3)
                                .foregroundStyle(.gray)
                        }
                        
                        Spacer()
                        
                        Button {
                            // 텍스트필드에서 입력이 없을 시 임의로 주소를 장소명으로,
                            // 입력이 있을 시 입력한 텍스트를 장소명으로 지정
                            if placeOfText == "" {
                                destination = address
                            } else {
                                destination = placeOfText
                            }
                            isClickedPlace = false
                            promiseLocation = addLocationStore.setLocation(destination: destination, address: address, latitude: coordX, longitude: coordY)
                            print(destination)
                            print(address)
                            print(coordX)
                            print(coordY)
                            dismiss()
                        } label: {
                            Text("장소 선택하기")
                                .frame(width: 290, height: 20)
                        }
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.roundedRectangle(radius: 5))
                        .padding(.bottom, 10)
                    }
                }
        }
    }
}

#Preview {
    TestingsAddLocation(destination: .constant(""), address: .constant(""), coordX: .constant(0.0), coordY: .constant(0.0), placeOfText: .constant("placeOfText"), selectedPlace: .constant(false), isClickedPlace: .constant(false), promiseLocation: .constant(PromiseLocation(destination: "서울시청", address: "", latitude: 37.5665, longitude: 126.9780)))
}
