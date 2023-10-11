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
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    @Binding var isClickedPlace: Bool
    @Binding var addLocationButton: Bool
    @Binding var destination: String
    @Binding var address: String
    @Binding var coordX: Double
    @Binding var coordY: Double
    @Binding var promiseLocation: PromiseLocation
    
    var body: some View {
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
                                Button {
                                    isClickedPlace = false
                                    destination = ""
                                    address = ""
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundStyle(.white, .red)
                                }
                                .shadow(radius: 5)
                                .padding(.top, 5)
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
                            
                            Button {
                                promiseLocation = addLocationStore.setLocation(destination: destination, address: address, latitude: coordX, longitude: coordY)
                                addLocationButton = true
                                print("확정 장소: \(promiseLocation.destination)")
                                print("확정 주소: \(promiseLocation.address)")
                                print("확정 위도: \(promiseLocation.latitude)")
                                print("확정 경도: \(promiseLocation.longitude)")
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
        .onDisappear {
            coordX = 0.0
            coordY = 0.0
        }
    }
}

#Preview {
    AddPlaceButtonCell(isClickedPlace: .constant(true), addLocationButton: .constant(false),
                       destination: .constant("동서울종합터미널"), address: .constant("서울 광진구 강변역로 50"), coordX: .constant(0.0), coordY: .constant(0.0), promiseLocation: .constant(PromiseLocation(destination: "", address: "", latitude: 37.5665, longitude: 126.9780)))
}
