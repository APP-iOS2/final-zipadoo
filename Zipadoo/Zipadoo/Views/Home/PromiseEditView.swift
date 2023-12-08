//
//  PromiseEditView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/10/11.
//

import CoreLocation
import FirebaseCore
import FirebaseFirestore
import FirebaseFirestoreSwift
import SwiftUI

struct PromiseEditView: View {
    
    @Environment(\.dismiss) private var dismiss
    /// 받아온 약속
    @Binding var promise: Promise
    /// 수정후 true변경, 홈뷰로 이동
    @Binding var navigationBackToHome: Bool

    @ObservedObject private var promiseViewModel: PromiseViewModel = PromiseViewModel()
    @StateObject var friendsStore: FriendsStore = FriendsStore()
    @StateObject var userStore: UserStore = UserStore()
    
    // 변경하려는 데이터
    @State private var editedPromiseTitle: String = ""
    @State private var editedPromiseDate: Date = Date()
    @State private var editedDestination: String = ""
    @State private var editedAddress: String = ""
    @State private var destinationLatitude = 0.0 // 약속장소 위도
    @State private var destinationLongitude = 0.0 // 약속장소 경도
    @State private var penalty: Int = 0 // 지각비 수정
    /// 참여자들 User타입
    @State var editSelectedFriends: [User] = []
    
    // 수정 시트
    /// 데이트피커
    @State private var isShowingDatePicker = false
    /// 장소수정 시트
    @State var isShowingEditMapSheet: Bool = false
    /// 지각비 수정 시트
    @State private var isShowingPenalty: Bool = false
    /// 참여친구 수정 시트
    @State private var isShowingFriendsSheet: Bool = false
    /// 수정사항 저장 시트
    @State private var isShowingSaveAlert: Bool = false
    /// 수정 취소 시트
    @State private var isShowingCancelAlert: Bool = false

    /// 지각비 선택
    private let availableValues = [0, 100, 200, 300, 400, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var sheetTitle: String = "약속장소 수정"
    
    // 심볼 이펙트
//    @State private var animate = false
//    @State private var animate1 =  false
//    @State private var animate2 =  false
//    @State private var animate3 =  false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    // MARK: - 약속 이름 수정
                    promiseCell(.promiseTitle)
                    
                    // MARK: - 약속 날짜/시간 수정
                    promiseCell(.promiseDate)

                    // MARK: - 약속 장소 수정
                    promiseCell(.promiseDestination)
                    
                    // MARK: - 지각비 수정
                    promiseCell(.promisePenalty)
                    
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
//                            .symbolEffect(.bounce, value: animate)
                            .onTapGesture {
//                                animate.toggle()
                                
                                // 친구수정버튼을 누른 후에만 친구목록이 패치되도록
                                Task {
                                    try await friendsStore.fetchFriends()
                                }
                                isShowingFriendsSheet.toggle()
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
                                    HStack {
                                        // 참여자 프로필,닉네임 나열
                                        FriendCellView(selectedFriends: $editSelectedFriends)
                                            .padding()
                                            .padding(.trailing, -50)
                                    }
                                    .padding(.leading, -20)
                                    .padding(.trailing, 50)
                                }
                                .frame(height: 90)
                                .scrollIndicators(.hidden)
                            }
                        }
                        .padding(.bottom)
                } // VStack
                .padding(.horizontal, 15)
            } // scrollView
            .navigationTitle("약속 수정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        } // navigationStack
        .navigationBarItems(
            leading: Button("취소") {
                isShowingCancelAlert = true
            },
            trailing: Button("저장") {
                isShowingSaveAlert = true
            }
        )
        // MARK: - 수정 시트 뷰
        .sheet(isPresented: $isShowingDatePicker) {
            EditDatePickerView(date: $editedPromiseDate, showPicker: $isShowingDatePicker, promise: $promise)
                .presentationDetents([.fraction(0.7)])
        }
        .sheet(isPresented: $isShowingEditMapSheet) { // coordXXX, coordYYY
            OneMapView(promiseViewModel: promiseViewModel, destination: $editedDestination, address: $editedAddress, coordXXX: $destinationLatitude, coordYYY: $destinationLongitude, sheetTitle: $sheetTitle)
        }
        .sheet(isPresented: $isShowingPenalty, content: {
            HStack {
                Spacer()
                Button {
                    isShowingPenalty.toggle()
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
        .sheet(isPresented: $isShowingFriendsSheet) {
            FriendsListView(isShowingSheet: $isShowingFriendsSheet, selectedFriends: $editSelectedFriends)
        }
        .alert(isPresented: $isShowingSaveAlert) {
            Alert(
                title: Text("약속을 수정합니다."),
                primaryButton: .destructive(Text("취소"), action: {
//                    dismiss()
                }),
                secondaryButton: .default(Text("확인"), action: {
                    promiseViewModel.updatePromise(promise: promise, editSelectedFriends: editSelectedFriends, editedPromiseTitle: editedPromiseTitle, editedPromiseDate: editedPromiseDate, editedDestination: editedDestination, editedAddress: editedAddress, destinationLatitude: destinationLatitude, destinationLongitude: destinationLongitude)
                    dismiss()
                    navigationBackToHome = true // 홈메인뷰 이동
                })
            )
        }
        .alert(isPresented: $isShowingCancelAlert) {
            Alert(
                title: Text("수정을 취소합니다."),
                primaryButton: .destructive(Text("취소"), action: {
                }),
                secondaryButton: .default(Text("확인"), action: {
                    dismiss()
                })
            )
        }
        // MARK: - onAppear
        .onAppear {
            // 약속의 정보들 가져와서 띄워주기
            editedPromiseTitle = promise.promiseTitle
            editedPromiseDate = Date(timeIntervalSince1970: promise.promiseDate)
            editedDestination = promise.destination
            editedAddress = promise.address
            destinationLatitude = promise.latitude
            destinationLongitude = promise.longitude
            penalty = promise.penalty
            
            // 자기자신을 제외한 친구들목록만 가져오기
            for id in promise.participantIdArray {
                if let loginUser = AuthStore.shared.currentUser {
                    if loginUser.id == id {
                        continue
                    }
                }
                Task {
                    if let friend = try await UserStore.fetchUser(userId: id) {
                        editSelectedFriends.append(friend)
                    }
                }
            }
        }
    } // body
    
    /// 약속 정보에 따른 cell
    private func promiseCell(_ cellType: PromiseCellType) -> some View {
        return VStack(alignment: .leading) {
            // 소제목
            Text(cellType.cellTitle(cellType))
                .font(.title3)
                .foregroundColor(.secondary)
                .fontWeight(.semibold)
                .padding(.top, 25)
            // 약속날짜/시간일때만 추가되는 문구
            if cellType == .promiseDate {
                Text("약속 시간 30분 전부터 위치공유가 시작됩니다.")
                    .foregroundColor(.red.opacity(0.8))
                    .font(.footnote)
            }
            
            // 약속이름 수정일때와 나머지경우에 따라 다른 뷰 반환
            HStack {
                switch cellType {
                case .promiseTitle:
                    TextField("약속 이름을 수정해주세요", text: $editedPromiseTitle)
                        .fontWeight(.semibold)
                        .autocorrectionDisabled()
                        .autocapitalization(.none)
                        .onChange(of: editedPromiseTitle) {
                            if editedPromiseTitle.count > 15 { editedPromiseTitle = String(editedPromiseTitle.prefix(15)) }
                        }
                    // 15자까지 쓸 수 있도록
                    Text("\(editedPromiseTitle.count)/15")
                        .foregroundColor(.secondary)
                    
                default:
                    Group {
                        Button {
                            // 시트 노출
                            switch cellType {
                            case .promiseDate: isShowingDatePicker.toggle()
                            case .promiseDestination: isShowingEditMapSheet.toggle()
                            case .promisePenalty: isShowingPenalty.toggle()
                            default: break
                            }
                        } label: {
                            HStack {
                                Text(getPromiseData(cellType)) // 약속 정보 띄우기
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: cellType.systemImageName(cellType))
                                    .foregroundColor(.primary)
                                    .font(.title3)
                                    .fontWeight(.semibold)
//                            .symbolEffect(.bounce, value: animate1)
                            }
                        }
                    }
                }
            } // HStack
            .padding(.top, 10)
            
            // 모두 공통되는 부분
            Divider()
                .frame(maxWidth: .infinity)
                .overlay {
                    Color.secondary
                }
        } // VStack
    }
    
    /// 약속의 정보를 String타입으로 반환해주는 함수
    func getPromiseData(_ cellType: PromiseCellType) -> String {
        
        switch cellType {
        case .promiseDate:
            let time = editedPromiseDate.formatted(date: .omitted, time: .shortened)
            let date = editedPromiseDate.formatted(date: .abbreviated, time: .omitted)
            return "\(time), \(date)"
        case .promiseDestination: return editedDestination
        case .promisePenalty: return "\(penalty)원"
        default: return ""
        }
    }
}

// #Preview {
//    PromiseEditView()
// }
