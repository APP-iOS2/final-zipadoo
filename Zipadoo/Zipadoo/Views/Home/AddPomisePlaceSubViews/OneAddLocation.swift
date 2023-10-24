//
//  TestingsAddLocation.swift
//  Zipadoo
//
//  Created by 김상규 on 10/12/23.
//

import SwiftUI

/// 직접 장소 설정 시 띄워지는 장소 선택뷰
struct OneAddLocation: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var promiseViewModel: PromiseViewModel
    
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordXXX: Double
    @Binding var coordYYY: Double
    @Binding var placeOfText: String
    @Binding var selectedPlace: Bool
    @Binding var isClickedPlace: Bool
//    @Binding var promiseLocation: PromiseLocation
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    var body: some View {
        // MARK: - 화면을 클릭해서 장소를 선택한 값이 true라면 ZStack 안의 내용들이 표시됨
        if selectedPlace == true {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 15)
                    .overlay {
                        VStack {
                            Spacer()
                            // MARK: - 화면을 클릭해서 장소를 선택한 값이 true라면 해당 좌표에 대한 주소가 표시됨
                            if selectedPlace == true {
                                TextField(address, text: $placeOfText)
                                    .textFieldStyle(.roundedBorder)
                                    .padding(.horizontal)
                                    .frame(height: 30)
                            // MARK: - 화면을 클릭해서 장소를 선택한 값이 false라면 "약속 장소를 선택해 주세요" 텍스트를 표시함
                            } else {
                                Text("약속 장소를 클릭해 주세요")
                                    .font(.title3)
                                    .foregroundStyle(.gray)
                            }
                            
                            Spacer()
                            
                            // MARK: - 텍스트필드에서 입력이 없을 시 임의로 주소를 장소명으로, 입력이 있을 시 입력한 텍스트를 장소명으로 지정
                            Button {
                                if placeOfText == "" {
                                    destination = address
                                } else {
                                    destination = placeOfText
                                }
                                // 장소검색 이후 장소를 선택한 값은 false로 지정
                                isClickedPlace = false
                                
                                // MARK: - '장소 선택하기' 버튼을 클릭하면 위의 데이터값 + 위치(위,경도)값을 promiseLoaction 값으로 저장함
                                destination = destination
                                address = address
                                coordXXX = coordXXX
                                coordYYY = coordYYY
//                                promiseLocation = addLocationStore.setLocation(destination: destination, address: address, latitude: coordXXX, longitude: coordYYY)
                                print(destination)
                                print(address)
                                print(coordXXX)
                                print(coordYYY)
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
}

#Preview {
    OneAddLocation(promiseViewModel: PromiseViewModel(), destination: .constant(""), address: .constant(""), coordXXX: .constant(0.0), coordYYY: .constant(0.0), placeOfText: .constant("placeOfText"), selectedPlace: .constant(false), isClickedPlace: .constant(false))
}
