//
//  PromiseEditView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/10/11.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

struct PromiseEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var promise: Promise
    @State private var editedPromiseTitle: String = ""
    @State private var editedDestination: String = ""
    @State private var editedPromiseDate: Date = Date()
    @State private var mapViewSheet: Bool = false
    @State private var addFriendSheet: Bool = false
    @State private var addFriendsSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage = ""
    @State private var editSelectedFriends: [String] = []
    @State private var editPromiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
    @StateObject var editPromise: PromiseViewModel = PromiseViewModel()
    @StateObject private var authUser: AuthStore = AuthStore()
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    @StateObject var userStore: UserStore = UserStore()
    @Binding var selectedFriends: [User]
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소
//    @State private var coordX = 0.0 // 약속장소 위도
//    @State private var coordY = 0.0 // 약속장소 경도
    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값
    
    private let dbRef = Firestore.firestore().collection("Promise")
    
    var body: some View {
        NavigationView {
            Form {
                Text("약속 장소")
                    .font(.title2)
                    .bold()
                
                if editPromiseLocation.destination.isEmpty {
                    Text("\(editedDestination)")
                } else {
                    Text("\(editPromiseLocation.destination)")
                }
                
                HStack {
                    NavigationLink {
                        OneMapView(promiseViewModel: editPromise, destination: $destination, address: $address)
//                        MapView(destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, isClickedPlace: $isClickedPlace, promiseLocation: $promiseLocation)
                    } label: {
                        Text("지역검색")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                
                Text("약속 이름")
                    .font(.title2)
                    .bold()
                    .padding(.top, 40)
                
                TextField("약속 이름", text: $editedPromiseTitle)
                
                Text("약속 날짜")
                    .font(.title2)
                    .bold()
                    .padding(.top, 40)
                DatePicker("날짜", selection: $editedPromiseDate, displayedComponents: [.date, .hourAndMinute])
                
                HStack {
                    Text("친구추가")
                        .font(.title2)
                        .bold()
                    
                    Spacer()
                    
                    Button {
                        addFriendsSheet.toggle()
                    } label: {
                        Label("추가하기", systemImage: "plus")
                            .foregroundColor(.black)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.top, 40)
                
                RoundedRectangle(cornerRadius: 5)
                    .stroke(lineWidth: 0.5)
                    .frame(width: 315, height: 110)
                    .overlay {
                        HStack {
                            ScrollView(.horizontal) {
                                if selectedFriends.isEmpty {
                                    HStack {
                                        ForEach(editSelectedFriends, id: \.self) { friendId in
                                            if let friend = userStore.userFetchArray.first(where: { $0.id == friendId }) {
                                                EditFriendSellView(selectedFriends: $selectedFriends, friend: friend)
                                                    .padding()
                                                    .padding(.trailing, -50)
                                            }
                                        }
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                } else {
                                    HStack {
                                        ForEach(selectedFriends) { friend in
                                            FriendSellView(selectedFriends: $selectedFriends, friend: friend)
                                                .padding()
                                                .padding(.trailing, -50)
                                        }
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                }
                            }
                            .frame(height: 90)
                            .scrollIndicators(.hidden)
                        }
                    }
            }
            .onAppear {
                editedPromiseTitle = promise.promiseTitle
                editedDestination = promise.destination
                editedPromiseDate = Date(timeIntervalSince1970: promise.promiseDate)
                editSelectedFriends = promise.participantIdArray
                Task {
                    try await friendsStore.fetchFriends()
                }
            }
            .navigationBarItems(
                leading: Button("취소") {
                    dismiss()
                },
                trailing: Button("저장") {
                    updatePromise()
                    dismiss()
                }
            )
            .sheet(isPresented: $addFriendsSheet) {
                EditFriendsListVIew(isShowingSheet: $addFriendsSheet, selectedFriends: $selectedFriends)
            }
            .navigationTitle("약속 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func updatePromise() {
        let promiseRef = dbRef.document(promise.id)
        
        let updatedData: [String: Any] = [
            "promiseTitle": editedPromiseTitle,
            "promiseDate": editedPromiseDate.timeIntervalSince1970,
            "destination": destination,
            //            "participantIdArray": editSelectedFriends
            "participantIdArray": selectedFriends.map { $0.id }
        ]
        
        promiseRef.updateData(updatedData) { error in
            if let error = error {
                print("약속 수정 실패: \(error)")
            } else {
                print("약속이 성공적으로 수정되었습니다.")
                dismiss()
            }
        }
    }
}

struct EditFriendsListVIew: View {
    
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    
    @Binding var isShowingSheet: Bool
    @Binding var selectedFriends: [User]
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var editSelectedFriends: [String] = []
    @StateObject var userStore: UserStore = UserStore()
    
    // 더미데이터
    let friends = ["임병구", "김상규", "나예슬", "남현정", "선아라", "윤해수", "이재승", "장여훈", "정한두"]
    
    var body: some View {
        NavigationStack {
            RoundedRectangle(cornerRadius: 5)
                .stroke(lineWidth: 0.5)
                .frame(width: 315, height: 110)
                .overlay {
                    HStack {
                        ScrollView(.horizontal) {
                            if selectedFriends.isEmpty {
                                HStack {
                                    ForEach(editSelectedFriends, id: \.self) { friendId in
                                        if let friend = userStore.userFetchArray.first(where: { $0.id == friendId }) {
                                            FriendSellView(selectedFriends: $selectedFriends, friend: friend)
                                                .padding()
                                                .padding(.trailing, -50)
                                            
                                        }
                                    }
                                }
                                .padding(.leading, -20)
                                .padding(.trailing, 50)
                            } else {
                                HStack {
                                    ForEach(selectedFriends) { friend in
                                        FriendSellView(selectedFriends: $selectedFriends, friend: friend)
                                            .padding()
                                            .padding(.trailing, -50)
                                    }
                                }
                                .padding(.leading, -20)
                                .padding(.trailing, 50)
                            }
                        }
                        .frame(height: 90)
                        .scrollIndicators(.hidden)
                    }
                }
            
            List(friendsStore.friendsFetchArray) { friend in
                Button {
                    if !selectedFriends.contains(friend) {
                        selectedFriends.append(friend)
                        editSelectedFriends.append(friend.id)
                    } else {
                        showAlert = true
                        alertMessage = "\(friend.nickName)님은 이미 존재합니다."
                    }
                } label: {
                    HStack {
                        ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
                        
                        Text(friend.nickName)
                    }
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("알림"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("확인")) {
                        }
                    )
                }
            }
            .listStyle(.plain)
            .navigationTitle("친구 목록")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    try await friendsStore.fetchFriends()
                }
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        isShowingSheet.toggle()
                    } label: {
                        Text("완료")
                    }
                }
            }
        }
    }
}

// #Preview {
//    PromiseEditView()
// }
