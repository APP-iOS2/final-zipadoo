//
//  AddPromiseView.swift
//  Zipadoo
//  약속 추가 뷰
//
//  Created by 나예슬 on 2023/09/25.
//

import SwiftUI

struct AddPromiseView: View {
    
    // 환경변수
    @Environment(\.dismiss) private var dismiss
    
    // 저장될 변수
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    @State private var address = ""
    
    // 지각비 변수 및 상수 값
    @State private var selectedValue = 100
    let minValue = 100
    let maxValue = 10000
    let step = 100
    
    private let today = Calendar.current.startOfDay(for: Date())
    @State private var friends = ["병구", "상규", "예슬", "한두", "아라", "해수", "여훈"]
    @State private var addFriendSheet: Bool = false
    @State private var mapViewSheet: Bool = false
    @State private var promiseLocation: PromiseLocation = PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "")
    @State var addLocationStore: AddLocationStore = AddLocationStore()
    @State private var showingAlert: Bool = false
    
    enum Field: Hashable {
        case promiseTitle, date
    }
    
    @FocusState private var focusField: Field?
    
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
                            .focused($focusField, equals: .promiseTitle)
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
                        .focused($focusField, equals: .date)
                        .padding(.top, 10)
                    
                    // MARK: - 약속 장소 구현
                    Text("약속 장소")
                        .font(.title2)
                        .bold()
                        .padding(.top, 40)
                    
                    Button {
                        mapViewSheet = true
                    } label: {
                        Label("지역검색", systemImage: "mappin")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    .sheet(isPresented: $mapViewSheet, content: {
                        MapView(mapViewSheet: $mapViewSheet, promiseLocation: $promiseLocation)
                            .presentationDetents([.height(900)])
                    })
                    
                    Text(promiseLocation.address)
                        .font(.callout)
                    
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
                    
                    Picker(selection: $selectedValue, label: Text("지각비")) {
                        ForEach((minValue...maxValue).filter { $0 % step == 0 }, id: \.self, content: { value in
                            Text("\(value) 개").tag(value)
                        })
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(maxWidth: .infinity)
                    
                    Text("선택한 감자: \(selectedValue) 개")
                        .font(.title3)
                        .padding(.leading, 100)
                    
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
                    Button("") {
                        if promiseTitle.isEmpty {
                            focusField = .promiseTitle
                        } else if date == Date() {
                            focusField = .date
                        }
                    }
                }
                .padding(.horizontal, 15)
                .onAppear {
                    focusField = .promiseTitle
                }
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
                    }
                    .alert(isPresented: $showingAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("등록이 완료되었습니다."),
                            dismissButton:
                                    .default(Text("확인"),
                                             action: {
                                                 dismiss()
                                             })
                        )
                    }
                }
            }
            .sheet(isPresented: $addFriendSheet, content: {
                Text("AddFirendsSheet")
            })
            .onTapGesture {
                hideKeyboard()
            }
        }
    }
}

#Preview {
    AddPromiseView()
}
