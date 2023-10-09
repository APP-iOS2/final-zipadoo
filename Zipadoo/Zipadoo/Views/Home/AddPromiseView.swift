//
//  AddPromiseView.swift
//  Zipadoo
//  약속 추가 뷰
//
//  Created by 나예슬 on 2023/09/25.
//

import SwiftUI
import CoreLocation

struct AddPromiseView: View {
    
    // 환경변수
    @Environment(\.dismiss) private var dismiss
    
    var promiseViewModel: PromiseViewModel = PromiseViewModel()
    //    var user: User
    
    // 저장될 변수
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소
    @State private var coordX = 0.0 // 약속장소 위도
    @State private var coordY = 0.0 // 약속장소 경도
    
    // 지각비 변수 및 상수 값
    @State private var selectedValue: Int = 0
    let minValue: Int = 0
    let maxValue: Int = 5000
    let step: Int = 100
    
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var friends = ["병구", "상규", "예슬", "한두", "아라", "해수", "여훈"]
    @State private var addFriendSheet: Bool = false
    @State private var selectedFriends: [String] = ["김상규", "나예슬", "윤해수", "임병구"]
    @State private var mapViewSheet: Bool = false
    @State private var promiseLocation: PromiseLocation = PromiseLocation(destination: "", address: "", latitude: LocationManager().location?.coordinate.latitude ?? 0.0, longitude: LocationManager().location?.coordinate.longitude ?? 0.0) /// 장소에 대한 정보 값/// 장소명 값
    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값
    @State private var showingAlert: Bool = false
    @State private var showingPenalty: Bool = false
    
    var isAllWrite: Bool {
        return !promiseTitle.isEmpty &&
        Calendar.current.startOfDay(for: date) != today &&
        !promiseLocation.address.isEmpty
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                
                // MARK: - 약속 이름 작성 구현
                VStack(alignment: .leading) {
                    Text("약속 이름")
                        .font(.title2)
                        .bold()
                        .padding(.top, 15)
                    
                    HStack {
                        TextField("약속 이름을 입력해주세요.", text: $promiseTitle)
                            .onChange(of: promiseTitle) {
                                if promiseTitle.count > 15 {
                                    promiseTitle = String(promiseTitle.prefix(15))
                                }
                            }
                        
                        Text("\(promiseTitle.count)")
                            .foregroundColor(.gray)
                            .padding(.trailing, -7)
                        Text("/15")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.gray
                        }
                    
                    // MARK: - 약속 날짜/시간 선택 구현
                    Text("약속 날짜/시간")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    Text("약속시간 1시간 전부터 위치공유가 시작됩니다.")
                        .foregroundColor(.gray)
                    
                    DatePicker("날짜/시간", selection: $date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(.top, 10)
                    
                    // MARK: - 약속 장소 구현
                    Text("약속 장소")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    
                    HStack {
                        /// Sheet 대신 NavigationLink로 이동하여 장소 설정하도록 설정
                        NavigationLink {
                            AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
                        } label: {
                            Label("지역검색", systemImage: "mappin")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                        
                        Button {
                            mapViewSheet = true
                        } label: {
                            Text(promiseLocation.destination)
                                .font(.callout)
                        }
                        .sheet(isPresented: $mapViewSheet) {
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 50, height: 5)
                                        .foregroundStyle(Color.gray)
                                        .padding(.top, 10)
                                    
                                    PreviewPlaceOnMap(promiseLocation: $promiseLocation)
                                        .presentationDetents([.height(700)])
                                        .padding(.top, 15)
                                }
                        }
                        Spacer()
                    }
                    // MARK: - 지각비 구현
                    /*
                     지각비 구현 초기안
                     Text("지각비")
                     .font(.title2)
                     .bold()
                     .padding(.top, 40)
                     Text("100 단위로 입력 가능합니다.")
                     .foregroundColor(.gray)
                     
                     HStack {
                     TextField("지각 시 제출 할 감자수를 입력해주세요", text: $penaltyString, axis: .horizontal)
                     .frame(maxWidth: .infinity)
                     .textFieldStyle(.roundedBorder)
                     .keyboardType(.numberPad)
                     .multilineTextAlignment(.trailing)
                     Text("개")
                     }
                     */
                    
                    Text("지각비")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    Text("100 단위로 선택 가능합니다.")
                        .foregroundColor(.gray)
                    
                    HStack {
                        Button {
                            showingPenalty.toggle()
                        } label: {
                            Text("지각비를 선택해주세요.")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Text("\(selectedValue)개")
                            .font(.title3)
                            .padding(.leading, 100)
                    }
                    .padding(.top, 10)
                    
                    // MARK: - 약속 친구 추가 구현
                    HStack {
                        Text("친구추가")
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        Button {
                            addFriendSheet.toggle()
                            print("친구 추가")
                        } label: {
                            Label("추가하기", systemImage: "plus")
                                .foregroundColor(.black)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(.top, 40)
                    
                    AddFriendCellView()
                }
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("약속 추가")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        showingAlert.toggle()
                    } label: {
                        Text("등록")
                            .foregroundColor(isAllWrite ? .blue : .gray)
                    }
                    .disabled(!isAllWrite)
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("등록이 완료되었습니다."),
                            dismissButton:
                                    .default(Text("확인"),
                                             action: {
                                                 dismiss()
                                                 promiseViewModel.addPromise(Promise(
                                                    makingUserID: "유저ID" /*user.id*/, // 사용자 ID를 적절히 설정해야 합니다.
                                                    promiseTitle: promiseTitle,
                                                    promiseDate: date.timeIntervalSince1970, // 날짜 및 시간을 TimeInterval로 변환
                                                    destination: promiseLocation.destination,
                                                    address: promiseLocation.address,
                                                    latitude: promiseLocation.latitude,
                                                    longitude: promiseLocation.longitude,
                                                    participantIdArray: selectedFriends,
                                                    checkDoublePromise: false, // 원하는 값으로 설정
                                                    locationIdArray: []))
                                             })
                        )
                    }
                }
            }
            .sheet(isPresented: $showingPenalty, content: {
                Picker(selection: $selectedValue, label: Text("지각비")) {
                    ForEach((minValue...maxValue).filter { $0 % step == 0 }, id: \.self, content: { value in
                        Text("\(value)").tag(value)
                    })
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .presentationDetents([.height(200)])
            })
            .sheet(isPresented: $addFriendSheet) {
                FriendsListVIew(isShowingSheet: $addFriendSheet, selectedFriends: $selectedFriends)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    AddPromiseView(/*user: User(id: "", name: "", nickName: "", phoneNumber: "", profileImageString: "")*/)
}
