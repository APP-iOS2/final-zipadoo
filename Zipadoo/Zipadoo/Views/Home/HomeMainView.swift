//
//  HomeMainView.swift
//  Zipadoo
//  약속 리스트 뷰
//
//  Created by 윤해수 on 2023/09/21.
//

import SwiftUI

/// 약속 리스트 뷰
struct HomeMainView: View {
    
    @StateObject private var loginUser: UserStore = UserStore()
    @StateObject private var promise: PromiseViewModel = PromiseViewModel()
    
    @State private var isShownFullScreenCover: Bool = false
    
    // 약속의 갯수 확인
    @State private var userPromiseArray: [Promise] = []
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // 약속 배열 값 존재하는지 확인.
//                if promise.promiseViewModel.isEmpty {
//                    Text("현재 약속이 1도 없어요!")
//                        .toolbar {
//                            ToolbarItem(placement: .topBarTrailing) {
//                                NavigationLink {
//                                    AddPromiseView()
//                                } label: {
//                                    Text("약속 추가")
//                                }
//                            }
//                        }
//                } else {
                    VStack {
                        ForEach(promise.promiseViewModel, id: \.self) { promise in
                            if let loginUserID = loginUser.currentUser?.id {
                                if loginUserID == promise.makingUserID {
                                    NavigationLink {
                                        PromiseDetailView()
                                    } label: {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text(promise.promiseTitle)
                                                    .font(.title)
                                                    .fontWeight(.bold)
                                                
                                                Spacer()
                                                
                                                Image(systemName: "map.fill")
                                                    .fontWeight(.bold)
                                                    .foregroundStyle(Color.white)
                                                    .padding(8)
                                                    .background(Color.black)
                                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                                    .overlay(
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .shadow(color: .black, radius: 1, x: 1, y: 1)
                                                            .opacity(0.3)
                                                    )
                                            }
                                            .padding(.vertical, 10)
                                    
                                    Group {
                                        HStack {
                                            Image(systemName: "pin")
                                            Text("장소 \(promise.destination)")
                                        }
                                        
                                        /// 저장된 promiseDate값을 Date 타입으로 변환
                                        let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                                        
                                        HStack {
                                            Image(systemName: "clock")
                                            Text("\(promise.promiseDate)")
                                        }
                                        .padding(.bottom, 20)
                                        
                                        HStack {
                                            Text("6km")
                                            Spacer()
                                            
                                            Group {
                                                HStack {
                                                    Image(systemName: "pin")
                                                    Text("장소 \(promise.destination)")
                                                }
                                                
                                                /// 저장된 promiseDate값을 Date 타입으로 변환
                                                let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
                                                
                                                HStack {
                                                    Image(systemName: "clock")
                                                    Text("\(datePromise)")
                                                }
                                                .padding(.bottom, 20)
                                                
                                                HStack {
                                                    Text("6km")
                                                    Spacer()
                                                    
                                                    Text("5,000원")
                                                        .fontWeight(.semibold)
                                                        .font(.title3)
                                                }
                                                .padding(.vertical, 10)
                                                
                                            }
                                            .font(.callout)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(.black).opacity(0.5)
                                            // 참여자의 ID를 통해 참여자 정보 가져오기
                                        }
                                        .padding()
                                        .overlay(
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .shadow(color: .black, radius: 15, x: 10, y: 10)
                                                    .opacity(0.1)
                                            }
                                        )
                                        .foregroundStyle(Color.black)
                                    }
                                    .padding()
                                } else {
                                    
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button {
                                isShownFullScreenCover.toggle()
                            } label: {
                                Text("약속 추가")
                            }
                            .fullScreenCover(isPresented: $isShownFullScreenCover, content: {
                                AddPromiseView()
                            })
                        }
                    }
                }
            }
        }
    }
//}

#Preview {
    HomeMainView()
}
