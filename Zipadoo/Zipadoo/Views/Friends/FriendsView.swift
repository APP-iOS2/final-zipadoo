//
//  FriendsView.swift
//  Zipadoo
//
//  Created by 장여훈 on 2023/09/21.
//

import SwiftUI

struct FriendsView: View {
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    /// 친구 삭제 알람
    @State private var isDeleteAlert: Bool = false
    /// segmentedControl 인덱스
    @State private var selectedSegmentIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("option", selection: $selectedSegmentIndex) {
                    Text("친구 목록").tag(0)
                    Text("요청 목록").tag(1)
                }
                
                VStack {
                    switch selectedSegmentIndex {
                    case 0:
                        friendListView
                    case 1:
                        friendRequestView
                    default:
                        friendListView
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .navigationTitle("친구 관리")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        FriendsRegistrationView()
                    } label: {
                        Label("Add", systemImage: "magnifyingglass")
                    }
                }
            }
            .alert(isPresented: $isDeleteAlert) {
                Alert(
                    title: Text(""),
                    message: Text("친구목록에서 삭제됩니다"),

                    primaryButton: .default(Text("취소"), action: {
                        isDeleteAlert = false
                    }),
                    secondaryButton: .destructive(Text("삭제"), action: {
                        isDeleteAlert = false
                        Task {
                            // 삭제 로직
                        }
                    })
                )
            }
            
        }
    }
    
    // MARK: - 친구 목록 뷰
    private var friendListView: some View {
        List {
            ForEach(friends, id: \.self) { friend in
                ZStack {
                    // 친구프로필 이동
                    NavigationLink(destination: MyPageView(), label: {
                        HStack {
                            ProfileImageView(imageString: "", size: .xSmall)
                            
                            Text(friend)
                        }
                    })
                    
                    // 친구 삭제 버튼
                    HStack {
                        Spacer()
                        
                        Text("삭제")
                            .padding(5)
                            .foregroundColor(.gray)
                            .background(.white)
                            .onTapGesture {
                                isDeleteAlert.toggle()
                            }
                    }
                     
                }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            }
        }
        .listStyle(.plain)
    }
    
    // MARK: - 요청목록 뷰
    private var friendRequestView: some View {
        List {
            ForEach(friends, id: \.self) { friend in
                
                ZStack {
                    // 친구프로필 이동
                    NavigationLink(destination: MyPageView(), label: {
                        HStack {
                            ProfileImageView(imageString: "", size: .xSmall)
                                
                            Text(friend)
                        }
                    })
                                             
                    HStack {
                        Spacer()
                        
                        // 수락
                        Text("수락")
                        .padding(5)
                        .foregroundColor(.green)
                        .background(.white)
                        .onTapGesture {
                            // 수락
                        }
                        .padding(.trailing, 4)
                        
                        // 거절 버튼
                        Button("거절") {
                            isDeleteAlert.toggle()
                        }
                        .padding(5)
                        .foregroundColor(.red)
                        .background(.white)
                        .onTapGesture {
                            // 거절
                        }
                        
                    }
                }
                .padding(EdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0))
            }
        }
        .listStyle(.plain)
        .alert(isPresented: $isDeleteAlert) {
            Alert(
                title: Text(""),
                message: Text("친구목록에서 삭제됩니다"),

                primaryButton: .default(Text("취소"), action: {
                    isDeleteAlert = false
                }),
                secondaryButton: .destructive(Text("삭제"), action: {
                    isDeleteAlert = false
                    Task {
                        // 삭제 로직
                    }
                })
            )
        }
    }
    
}

#Preview {
    NavigationStack {
        FriendsView()
    }
}
