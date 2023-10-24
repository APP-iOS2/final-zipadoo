//
//  PromiseEditView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/10/11.
//

import SwiftUI
import CoreLocation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseCore

struct PromiseEditView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var promise: Promise
    @Binding var navigationBackToHome: Bool
    @State private var editedPromiseTitle: String = ""
    @State private var editedDestination: String = ""
    @State private var editedAddress: String = ""
    @State private var editedPromiseDate: Date = Date()
    @State private var mapViewSheet: Bool = false
    @State private var addFriendSheet: Bool = false
    @State private var addFriendsSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage = ""
    @State private var editSelectedFriends: [String] = []
    @State private var locationIdArray: [String] = []
//    @State private var editPromiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
    @ObservedObject private var promiseViewModel: PromiseViewModel = PromiseViewModel()
    @StateObject private var authUser: AuthStore = AuthStore()
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    @StateObject var userStore: UserStore = UserStore()
    @State var selectedFriends: [User] = []
    @State var editPlaceSheet: Bool = false
    private let availableValues = [0, 100, 200, 300, 400, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var penalty: Int = 0
    @State private var showingPenalty: Bool = false
    @State private var sheetTitle: String = "약속장소 수정"
    @State private var previewPlaceSheet: Bool = false
    @State private var coordXXX = 0.0 // 약속장소 위도
    @State private var coordYYY = 0.0 // 약속장소 경도
    // 데이트피커
    @State private var showDatePicker = false
    @State private var isSelectedDataPickerOnce = false
    // 심볼 이펙트
    @State private var animate = false
    @State private var animate1 =  false
    @State private var animate2 =  false
    @State private var animate3 =  false
    
    private let dbRef = Firestore.firestore().collection("Promise")

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // MARK: - 약속 이름 수정
                    Text("약속 이름 수정")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    Text("")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    HStack {
                        TextField("약속 이름을 수정해주세요", text: $editedPromiseTitle)
                            .fontWeight(.semibold)
                            .onChange(of: editedPromiseTitle) {
                                if editedPromiseTitle.count > 15 {
                                    editedPromiseTitle = String(editedPromiseTitle.prefix(15))
                                }
                            }
                        
                        Text("\(editedPromiseTitle.count)")
                            .foregroundColor(.gray)
                            .padding(.trailing, -7)
                        Text("/15")
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                    // MARK: - 약속 날짜/시간 수정
                    Text("약속 날짜/시간")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    Text("약속 시간 30분 전부터 위치공유가 시작됩니다.")
                        .foregroundColor(.red.opacity(0.8))
                        .font(.footnote)
                    
                    HStack {
                        let time = editedPromiseDate.formatted(date: .omitted, time: .shortened)
                        
                        let date = editedPromiseDate.formatted(date: .abbreviated, time: .omitted)
                        
                        Text("\(time), \(date)")
                            .fontWeight(.semibold)
               
                        Spacer()
                        
                        // 버튼
                            Image(systemName: "calendar")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .symbolEffect(.bounce, value: animate1)
                    }
                    .padding(.top, 10)
                    .onTapGesture {
                        animate1.toggle()
                        showDatePicker.toggle()
                    }
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
//                    DatePicker("날짜/시간", selection: $editedPromiseDate, in: self.today..., displayedComponents: [.date, .hourAndMinute])
//                        .datePickerStyle(.compact)
//                        .labelsHidden()
//                        .padding(.top, 10)
                    
                    // MARK: - 약속 장소 수정
                    Text("약속 장소 수정")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    Text("") // 안내문구
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    /// Sheet 대신 NavigationLink로 이동하여 장소 설정하도록 설정
                Group {
                    HStack {
                        Button {
                            editPlaceSheet = true
                        } label: {
                            if !editedDestination.isEmpty {
                                Button {
                                    previewPlaceSheet = true
                                } label: {
                                    HStack {
                                        Text("\(editedDestination)")
                                            .font(.callout)
                                        Image(systemName: "chevron.forward")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 6)
                                            .padding(.leading, -5)
                                    }
                                }
                                .sheet(isPresented: $previewPlaceSheet) {
                                    VStack {
                                        RoundedRectangle(cornerRadius: 8)
                                            .frame(width: 50, height: 5)
                                            .foregroundStyle(Color.gray)
                                            .padding(.top, 10)
                                        
                                        PreviewPlaceOnMap(promiseViewModel: promiseViewModel, destination: $editedDestination, address: $editedAddress, coordXXX: $coordXXX, coordYYY: $coordYYY)
                                            .presentationDetents([.height(700)])
                                            .padding(.top, 15)
                                    }
                                }
                            }
                            Spacer()
                            
                            Image(systemName: "location.magnifyingglass")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                }
                .onTapGesture {
                    editPlaceSheet = true
                }
                .sheet(isPresented: $editPlaceSheet) {
                    OneMapView(promiseViewModel: promiseViewModel, destination: $editedDestination, address: $editedAddress, coordXXX: $coordXXX, coordYYY: $coordYYY, sheetTitle: $sheetTitle)
                }
                    // MARK: - 지각비 수정
                    Text("지각비 수정")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    Text("")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                    
                    Group {
                        Button {
                            showingPenalty.toggle()
                        } label: {
                            HStack {
                                Text("\(penalty)원")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                // 버튼
                                Image(systemName: "wonsign.circle")
                                    .foregroundColor(.primary)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .symbolEffect(.bounce, value: animate3)
                            }
                            .padding(.top, 10)
                        }
                        
                        Divider()
                            .frame(maxWidth: .infinity)
                            .overlay {
                                Color.secondary
                            }
                    }
                    .onTapGesture {
                        animate3.toggle()
                        showingPenalty.toggle()
                    }
                    // MARK: - 친구 수정
                    HStack {
                        Text("친구 수정")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Spacer()
                        
                        Image(systemName: "person.crop.circle.badge.plus")
                            .foregroundColor(.primary)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .symbolEffect(.bounce, value: animate)
                            .onTapGesture {
                                animate.toggle()
                                addFriendsSheet.toggle()
                            }
                    }
                    .padding(.top, 60)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(lineWidth: 0.5)
                        .foregroundColor(.secondary)
                        .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                        .frame(width: 360, height: 120)
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
                        .padding(.bottom)
                }
                .padding(.horizontal, 15)
                .onAppear {
                    editedPromiseTitle = promise.promiseTitle
                    editedPromiseDate = Date(timeIntervalSince1970: promise.promiseDate)
                    editedDestination = promise.destination
                    editedAddress = promise.address
                    coordXXX = promise.latitude
                    coordYYY = promise.longitude
                    penalty = promise.penalty
                    
                    for id in promise.participantIdArray {
                        if let loginUser = AuthStore.shared.currentUser {
                            if loginUser.id == id {
                                continue
                            }
                        }
                        Task {
                            if let friend = try await UserStore.fetchUser(userId: id) {
                                selectedFriends.append(friend)
                            }
                        }
                    }
                    
                    Task {
                        try await friendsStore.fetchFriends()
                    }
                }
                //MARK: - 약속 수정 관련 버튼
                .navigationBarItems(
                    leading: Button("취소") {
                        dismiss()
                    },
                    trailing: Button("저장") {
                        updatePromise()
                        dismiss()
                        navigationBackToHome = true
                    }
                )
                .sheet(isPresented: $addFriendsSheet) {
                    EditFriendsListVIew(isShowingSheet: $addFriendsSheet, selectedFriends: $selectedFriends)
                }
                .navigationTitle("약속 수정")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
            }
        }
        .sheet(isPresented: $showingPenalty, content: {
            HStack {
                Spacer()
                Button {
                    showingPenalty.toggle()
                } label: {
                    Text("결정")
                }
            }
            .padding(.horizontal, 15)
            
            Picker("지각비", selection: $penalty) {
                ForEach(availableValues, id: \.self) { value in

                    Text("\(value)").tag(value)
                }
            }
            .pickerStyle(WheelPickerStyle())
            .frame(maxWidth: .infinity)
            .presentationDetents([.height(300)])
        })
        .onTapGesture {
            hideKeyboard()
        }
        .sheet(isPresented: $showDatePicker) {
            CustomDatePicker(promiseViewModel: promiseViewModel, date: $editedPromiseDate, showPicker: $showDatePicker)
                .presentationDetents([.fraction(0.7)])
                .onAppear {
                    isSelectedDataPickerOnce = true
                }
        }
    }
    // MARK: - 약속 수정 함수
    func updatePromise() {
        let promiseRef = dbRef.document(promise.id)
        
        let IdArray = [AuthStore.shared.currentUser?.id ?? " - no id - "] + selectedFriends.map { $0.id }
        
        for id in IdArray {
            let friendLocation = Location(participantId: id, departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
            
            locationIdArray.append(friendLocation.id)
            
            LocationStore.addLocationData(location: friendLocation)
        }
        
        let updatedData: [String: Any] = [
            "promiseTitle": editedPromiseTitle,
            "promiseDate": editedPromiseDate.timeIntervalSince1970,
            "destination": editedDestination,
            "address": editedAddress,
            "latitude": coordXXX,
            "longitude": coordYYY,
            "participantIdArray": [AuthStore.shared.currentUser?.id ?? " - no id - "] + selectedFriends.map { $0.id },
            "penalty": penalty,
            "locationIdArray": locationIdArray
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
