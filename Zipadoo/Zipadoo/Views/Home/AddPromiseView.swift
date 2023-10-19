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
    
    @StateObject var promiseViewModel: PromiseViewModel
    //    var user: User
    
    // 저장될 변수
    @State private var id: String = ""
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소

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
    @State var promiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780) // 장소에 대한 정보 값
//    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
//    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값
    @State private var showingConfirmAlert: Bool = false
    @State private var showingCancelAlert: Bool = false
    @State private var showingPenalty: Bool = false
    
    var isAllWrite: Bool {
        return !promiseViewModel.promiseTitle.isEmpty &&
        // 당일 약속도 등록가능해야 함
//        Calendar.current.startOfDay(for: promiseViewModel.date) != today &&
        !promiseLocation.address.isEmpty
    }
    
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
                    
<<<<<<< HEAD

                        .foregroundColor(.red.opacity(0.7))

                        .font(.footnote)
                  
                    HStack {
                        let time = promiseViewModel.date.formatted(date: .omitted, time: .shortened)
                        
                        let date = promiseViewModel.date.formatted(date: .abbreviated, time: .omitted)
                        
                        Text("\(time), \(date)")
                            .fontWeight(.semibold)
               
                        Spacer()
                        
                        // 버튼
                            Image(systemName: "calendar")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .symbolEffect(.bounce, value: animate1)
                                .onTapGesture {
                                    animate1.toggle()
                                    showDatePicker.toggle()
                                }
                      
    
//                        DatePicker("날짜/시간", selection: $promiseViewModel.date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
//                            .datePickerStyle(.compact)
//                            .labelsHidden()
//.padding(.top, 10)
                    }
                    .padding(.top, 10)
        
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
=======
                    DatePicker("날짜/시간", selection: $promiseViewModel.date, in: self.today..., displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .padding(.top, 10)
>>>>>>> parent of 1a63335 ([DESIGN] 홈뷰,약속등록 뷰 디자인 변경 #218)
                    
                    // MARK: - 약속 장소 구현
                    Text("약속 장소")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    
                        /// Sheet 대신 NavigationLink로 이동하여 장소 설정하도록 설정
                    HStack {
                        NavigationLink {
                            //                            AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, promiseLocation: $promiseLocation)
                            OneMapView(destination: $destination, address: $address, promiseLocation: $promiseLocation)
                        } label: {
                            Label("지역검색", systemImage: "mappin")
                                .foregroundColor(.white)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Spacer()
                        // MARK: promiseViewModel.promiseLocation.destination로 장소등록을 할 때 장소명이 나오지 않아서 promiseLocation.destination으로 수정
                        if !promiseLocation.destination.isEmpty {
                            Button {
                                mapViewSheet = true
                            } label: {
                                HStack {
                                    Text("\(promiseLocation.destination)")
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
                                    
                                    PreviewPlaceOnMap(promiseLocation: $promiseLocation)
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
                        
                        Text("\(selectedValue)개")
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
                                                 Task {
                                                     do {
                                                         try await promiseViewModel.addPromiseData()
                                                         
                                                         dismiss()                       
                                                     } catch {
                                                         print("등록 실패")
                                                     }
                                                 }
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
                                
                                promiseViewModel.id = ""
                                promiseViewModel.promiseTitle = ""
                                promiseViewModel.date = Date()
                                promiseViewModel.destination = "" // 약속 장소 이름
                                promiseViewModel.address = "" // 약속장소 주소
                                promiseViewModel.coordX = 0.0 // 약속장소 위도
                                promiseViewModel.coordY = 0.0 // 약속장소 경도
                                /// 장소에 대한 정보 값
                                promiseViewModel.promiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
                                /// 지각비 변수 및 상수 값
                                promiseViewModel.selectedValue = 0
                                /// 선택된 친구 초기화
                                promiseViewModel.selectedFriends = []
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
<<<<<<< HEAD
        .sheet(isPresented: $showDatePicker) {
            CustomDatePicker(promiseViewModel: promiseViewModel, date: $promiseViewModel.date, showPicker: $showDatePicker)

                .presentationDetents([.fraction(0.7)])

        }
    }
}

// Custom Date Picker...
struct CustomDatePicker: View {
    @StateObject var promiseViewModel: PromiseViewModel
    private let today = Calendar.current.startOfDay(for: Date())
    @Binding var date: Date
    @Binding var showPicker: Bool
    
    var body: some View {
        
        ZStack {

            Text("")

            // Blur Effect...
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()
            DatePicker("", selection: $promiseViewModel.date ,in: self.today..., displayedComponents: [.date, .hourAndMinute])
                .datePickerStyle(.graphical)
                .labelsHidden()
            
            // Close Button...
            Button {
                
                withAnimation {
                    showPicker.toggle()
                }
                
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.primary)
            
            }
            .padding(10)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)

        }
        .opacity(showPicker ? 1 : 0)
=======
>>>>>>> parent of 1a63335 ([DESIGN] 홈뷰,약속등록 뷰 디자인 변경 #218)
    }
}

#Preview {
    AddPromiseView(promiseViewModel: PromiseViewModel()/*user: User(id: "", name: "", nickName: "", phoneNumber: "", profileImageString: "")*/)
}
