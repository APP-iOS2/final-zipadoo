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
    
    @StateObject private var promiseViewModel: PromiseViewModel = PromiseViewModel()
    //    var user: User
    

    // 지각비관련 변수
    let minValue: Int = 0
    let maxValue: Int = 5000
    let step: Int = 100

    // 지각비 변수 및 상수 값
    @State private var selectedValue: Int = 0
    private let availableValues = [0, 100, 200, 300, 400, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]

    
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var addFriendSheet: Bool = false
    
    @State private var mapViewSheet: Bool = false
    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값
    @State private var showingConfirmAlert: Bool = false
    @State private var showingCancelAlert: Bool = false
    @State private var showingPenalty: Bool = false
    
    var isAllWrite: Bool {
        return !promiseViewModel.promiseTitle.isEmpty &&
        Calendar.current.startOfDay(for: promiseViewModel.date) != today &&
        !promiseViewModel.promiseLocation.address.isEmpty
    }
    
    @State private var addPromise: Promise = Promise()
    
    @StateObject private var promise: PromiseViewModel = PromiseViewModel()
    @StateObject private var authUser: AuthStore = AuthStore()
    
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
                        TextField("약속 이름을 입력해주세요.", text: $promiseViewModel.promiseTitle)
                        
                            .onChange(of: promiseViewModel.promiseTitle) {
                                if promiseViewModel.promiseTitle.count > 15 {
                                    promiseViewModel.promiseTitle = String(promiseViewModel.promiseTitle.prefix(15))
                                }
                            }
                        
                        Text("\(promiseViewModel.promiseTitle.count)")
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
                    
                    // MARK: - 약속 날짜/시간 선택 구현
                    Text("약속 날짜/시간")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    Text("약속시간 1시간 전부터 위치공유가 시작됩니다.")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    
                    DatePicker("날짜/시간", selection: $promiseViewModel.date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
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
                            AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $promiseViewModel.destination, address: $promiseViewModel.address, coordX: $promiseViewModel.coordX, coordY: $promiseViewModel.coordY, promiseLocation: $promiseViewModel.promiseLocation)
                        } label: {
                            Label("지역검색", systemImage: "mappin")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        if !promiseViewModel.promiseLocation.destination.isEmpty {
                            Button {
                                mapViewSheet = true
                            } label: {
                                HStack {
                                    Text("\(promiseViewModel.promiseLocation.destination)")
                                        .font(.callout)
                                    Image(systemName: "chevron.forward")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 6)
                                        .padding(.leading, -5)
                                }
                            }
                            .sheet(isPresented: $mapViewSheet) {
                                VStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 50, height: 5)
                                        .foregroundStyle(Color.gray)
                                        .padding(.top, 10)
                                    
                                    PreviewPlaceOnMap(promiseLocation: $promiseViewModel.promiseLocation)
                                        .presentationDetents([.height(700)])
                                        .padding(.top, 15)
                                }
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
                    Text("500 단위로 선택 가능합니다.")
                        .foregroundColor(.gray)
                    
                    HStack {
                        Button {
                            showingPenalty.toggle()
                        } label: {
                            Text("지각비를 선택해주세요.")
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        
                        Text("\(promiseViewModel.selectedValue)개")
                            .font(.title3)
                            .padding(.leading, 100)
                    }
                    .padding(.top, 10)
                    
                    // MARK: - 약속 친구 추가 구현
                    AddFriendCellView(selectedFriends: $promiseViewModel.selectedFriends)
                }
                .padding(.horizontal, 15)
            }
            .scrollIndicators(.hidden)
            .navigationTitle("약속 추가")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    // MARK: - 약속 등록 버튼 구현
                    Button {
                        showingConfirmAlert.toggle()
                    } label: {
                        Text("등록")
                            .foregroundColor(isAllWrite ? .blue : .gray)
                    }
                    .disabled(!isAllWrite)
                    .alert(isPresented: $showingConfirmAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("등록이 완료되었습니다."),
                            dismissButton:
                                    .default(Text("확인"),
                                             action: {
                                                 dismiss()
                                                 promiseViewModel.addPromiseData()
                                             })
                        )
                    }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        showingCancelAlert.toggle()
                    } label: {
                        Text("취소")
                            .foregroundColor(.red)
                            .bold()
                    }
                    .alert(isPresented: $showingCancelAlert) {
                        Alert(
                            title: Text("약속 등록을 취소합니다."),
                            message: Text("작성 중인 내용은 저장되지 않습니다."),
                            primaryButton: .destructive(Text("등록 취소"), action: {
                                dismiss()
                            }),
                            secondaryButton: .default(Text("계속 작성"), action: {
                                
                            })
                        )
                    }
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
                

                Picker("지각비", selection: $selectedValue) {
                    ForEach(availableValues, id: \.self) { value in

                        Text("\(value)").tag(value)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .frame(maxWidth: .infinity)
                .presentationDetents([.height(300)])
            })
            //            .sheet(isPresented: $addFriendSheet) {
            //                FriendsListVIew(isShowingSheet: $addFriendSheet, selectedFriends: $selectedFriends)
            //            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    AddPromiseView(/*user: User(id: "", name: "", nickName: "", phoneNumber: "", profileImageString: "")*/)
}

