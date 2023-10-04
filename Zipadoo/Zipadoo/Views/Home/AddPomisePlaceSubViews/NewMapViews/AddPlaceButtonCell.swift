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
                    ZStack {
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
                                .padding(.top, 5)
                                .padding(.trailing, 6)
                            }
                            Spacer()
                        }
                        
                        VStack {
                            Spacer()
                            
                            Text(promiseLocation.address)
                                .font(.title3)
                                .padding(.top)
                                .padding(.horizontal)
                            
                            Spacer()
                            
                            Button {
                                addLocationButton = true
                                print(promiseLocation.latitude)
                                print(promiseLocation.longitude)
                                print(promiseLocation.address)
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
    AddPlaceButtonCell(isClickedPlace: .constant(true), addLocationButton: .constant(false), promiseLocation: PromiseLocation(latitude: 0.0, longitude: 0.0, address: "서울시 강남구 압구정로 165"))
}


