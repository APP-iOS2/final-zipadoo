//
//  AddPlaceButtonCell.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit

// MARK: - 장소 등록 버튼 뷰모델
/// 장소 검색 이후 장소 등록을 위한 뷰모델
struct AddPlaceButtonCell: View {
    @Environment(\.dismiss) private var dismiss /// 이전 뷰(AddPromiseView)로 돌아가는 함수
    @ObservedObject var promiseViewModel: PromiseViewModel
    var addLocationStore: AddLocationStore = AddLocationStore()
    @Binding var isClickedPlace: Bool
    @Binding var placeOfText: String
    @Binding var addLocationButton: Bool
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordXXX: Double
    @Binding var coordYYY: Double
    
    var body: some View {
        if isClickedPlace == true {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.white)
                    .frame(width: 350, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .shadow(radius: 15)
                    .overlay {
                        ZStack {
                            VStack {
                                HStack {
                                    Spacer()
                                    // X 버튼을 클릭 시 해당 장소에 대한 데이터 값들이 초기화됨
                                    Button {
                                        isClickedPlace = false
                                        destination = ""
                                        address = ""
                                        placeOfText = ""
                                    } label: {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundStyle(.white, .red)
                                    }
                                    .shadow(radius: 5)
                                    .padding(.top, 2)
                                    .padding(.trailing, 6)
                                }
                                Spacer()
                            }
                            
                            VStack {
                                Spacer()
                                
                                Text(destination)
                                    .font(.title3)
                                    .padding(.top)
                                    .padding(.horizontal)
                                
                                Spacer()
                                
                                // 클릭한 장소에 대해 선택하기 버튼을 클릭하면 해당 장소에 대한 값들을 promiseLocation에 입력시킴
                                Button {
                                    destination = destination
                                    address = address
                                    coordXXX = coordXXX
                                    coordYYY = coordYYY
                                    /*addLocationStore.setLocation(destination: destination, address: address, latitude: coordXXX, longitude: coordYYY)*/
                                    addLocationButton = true
                                    print("확정 장소: \(destination)")
                                    print("확정 주소: \(address)")
                                    print("확정 위도: \(coordXXX)")
                                    print("확정 경도: \(coordYYY)")
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
            // AddPlaceButtonCell이 보여지지 않을 시, 위치값들을 초기화 시킴
//            .onDisappear {
//                coordXXX = 0.0
//                coordYYY = 0.0
//            }
        }
    }
}

//#Preview {
//    AddPlaceButtonCell(isClickedPlace: .constant(true), addLocationButton: .constant(false),
//                       destination: .constant("동서울종합터미널"), address: .constant("서울 광진구 강변역로 50"), coordX: .constant(0.0), coordY: .constant(0.0), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latiid: UUID, tude: 37.5665, longitude: 126.9780)))
//}
