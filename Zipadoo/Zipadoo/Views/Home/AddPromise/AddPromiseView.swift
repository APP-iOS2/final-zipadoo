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
    
    /// 환경변수
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var promiseViewModel: PromiseViewModel = PromiseViewModel()
    
    /// 입력받은 약속 이름 값
    @State private var promiseTitle: String = ""
    @State private var date = Date()
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소
    @State private var coordXXX = 0.0 // 약속장소 위도
    @State private var coordYYY = 0.0 // 약속장소 경도
    
    @State private var sheetTitle: String = "약속 장소 선택"
    
    /// 지각비 변수 및 상수 값
    @State private var penalty: Int = 0
    private let availableValues = [0, 100, 200, 300, 400, 500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    
    /// 약속에 참여할 친구배열
    @State private var selectedFriends: [User] = []
    
    /// 약속 장소 등록 버튼 토글값
    @State private var isShowAddPlaceMapSheet: Bool = false
    /// 프리뷰 버튼 클릭값
    @State private var isPreviewPlaceSheet: Bool = false
    /// 지각비 설정 토글값
    @State private var isShowPenalty: Bool = false
    /// 약속 등록 버튼 토글값
    @State private var isShowConfirmAlert: Bool = false
    /// 약속 취소 버튼 토글값
    @State private var isShowCancelAlert: Bool = false
    
    /// DatePicker Sheet 실행 값
    @State private var isShowDatePicker = false
    @State private var isSelectedDataPickerOnce = false
    
    // 심볼 이펙트
    @State private var isShowCalendarEffect =  false
    @State private var isShowPenaltyEffect =  false
    
    var isAllWrite: Bool {
        return !promiseTitle.isEmpty && isSelectedDataPickerOnce && !address.isEmpty /*&& !selectedFriends.isEmpty*/
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                // MARK: - 약속 이름 작성 구현
                VStack(alignment: .leading) {
                    Text("약속 이름")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    
                    HStack {
                        TextField("약속 이름을 입력해주세요.", text: $promiseTitle)
                            .autocapitalization(.none)
                            .fontWeight(.semibold)
                            .onChange(of: promiseTitle) {
                                if promiseTitle.count > 15 {
                                    promiseTitle = String(promiseTitle.prefix(15))
                                }
                            }
                        
                        Text("\(promiseTitle.count)/15")
                            .foregroundColor(.gray)
                    } // HStack
                    .padding(.top, 10)
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                    
                    // MARK: - 약속 날짜/시간 선택 구현
                    Text("약속 날짜/시간")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    
                    Text("약속 시간 30분 전부터 위치공유가 시작됩니다.")
                        .foregroundColor(.red.opacity(0.8))
                        .font(.footnote)
                    
                    HStack {
                        let time = date.formatted(date: .omitted, time: .shortened)
                        
                        let date = date.formatted(date: .abbreviated, time: .omitted)
                        
                        Text("\(time), \(date)")
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        Image(systemName: "calendar")
                            .foregroundColor(.primary)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .symbolEffect(.bounce, value: isShowCalendarEffect)
                    } // HStack
                    .padding(.top, 10)
                    .onTapGesture {
                        isShowCalendarEffect.toggle()
                        isShowDatePicker.toggle()
                    }
                    
                    Divider()
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Color.secondary
                        }
                    
                    // MARK: - 약속 장소 구현
                    Text("약속 장소")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    
                    Group {
                        HStack {
                            Button {
                                isShowAddPlaceMapSheet = true
                            } label: {
                                if !destination.isEmpty {
                                    Button {
                                        isPreviewPlaceSheet = true
                                    } label: {
                                        HStack {
                                            Text("\(destination)")
                                                .font(.callout)
                                            Image(systemName: "chevron.forward")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 6)
                                                .padding(.leading, -5)
                                        }
                                    }
                                    .sheet(isPresented: $isPreviewPlaceSheet) {
                                        VStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .frame(width: 50, height: 5)
                                                .foregroundStyle(Color.gray)
                                                .padding(.top, 10)
                                            
                                            PreviewPlaceOnMap(promiseViewModel: promiseViewModel, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY)
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
                        isShowAddPlaceMapSheet = true
                    }
                    
                    // MARK: - 지각비 구현
                    Text("지각비")
                        .font(.title3)
                        .foregroundColor(.secondary)
                        .fontWeight(.semibold)
                        .padding(.top, 25)
                    
                    Group {
                        Button {
                            isShowPenalty.toggle()
                        } label: {
                            HStack {
                                Text("\(penalty)원")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                Image(systemName: "wonsign.circle")
                                    .foregroundColor(.primary)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .symbolEffect(.bounce, value: isShowPenaltyEffect)
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
                        isShowPenaltyEffect.toggle()
                        isShowPenalty.toggle()
                    }
                    
                    // MARK: - 약속 친구 추가 구현
                    AddFriendCellView(selectedFriends: $selectedFriends)
                    
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
                        isShowConfirmAlert.toggle()
                    } label: {
                        Text("등록")
                            .foregroundColor(isAllWrite ? .blue : .gray)
                    }
                    .disabled(!isAllWrite)
                    .alert(isPresented: $isShowConfirmAlert) {
                        Alert(
                            title: Text(""),
                            message: Text("등록이 완료되었습니다."),
                            dismissButton:
                                    .default(Text("확인"),
                                             action: {
                                                 let makingUserID = AuthStore.shared.currentUser?.id ?? "not ID"
                                                 var participantIds = [makingUserID]
                                                 var locationIds: [String] = []
                                                 
                                                 for friend in selectedFriends {
                                                     participantIds.append(friend.id)
                                                 }
                                                 
                                                 for id in participantIds {
                                                     Task {
                                                         let participantsLocation = Location(participantId: id, departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0, arriveTime: 0)
                                                         locationIds.append(participantsLocation.id)
                                                         
                                                         LocationStore.addLocationData(location: participantsLocation) // 파베에 Location저장
                                                     }
                                                 }
                                                 
                                                 let promise = Promise(id: UUID().uuidString, makingUserID: makingUserID, promiseTitle: promiseTitle, promiseDate: date.timeIntervalSince1970, destination: destination, address: address, latitude: coordXXX, longitude: coordYYY, participantIdArray: participantIds, checkDoublePromise: false, locationIdArray: locationIds, penalty: penalty)
                                                 
                                                 Task {
                                                     do {
                                                         try await promiseViewModel.addPromiseData(promise: promise)
                                                         
                                                         dismiss()
                                                     } catch {
                                                         print("등록 실패")
                                                     }
                                                 }
                                             })
                        )} // alert
                } // ToolbarItem confirmationAction
                
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isShowCancelAlert.toggle()
                    } label: {
                        Text("취소")
                            .foregroundColor(.red)
                            .bold()
                    }
                    .alert(isPresented: $isShowCancelAlert) {
                        Alert(
                            title: Text("약속 등록을 취소합니다."),
                            message: Text("작성 중인 내용은 저장되지 않습니다."),
                            primaryButton: .destructive(Text("등록 취소"), action: {
                                dismiss()
                            }),
                            secondaryButton: .default(Text("계속 작성"), action: {
                            })
                        )
                    } // alert
                } // ToolbarItem cancellationAction
            } // toolbar
            .onTapGesture {
                hideKeyboard()
            }
        } // NavigationStack
        .sheet(isPresented: $isShowDatePicker) {
            CustomDatePicker(promiseViewModel: promiseViewModel, date: $date, showPicker: $isShowDatePicker)
                .presentationDetents([.fraction(0.7)])
                .onAppear {
                    isSelectedDataPickerOnce = true
                }
        } // 날짜/시간 선택 sheet
        .sheet(isPresented: $isShowAddPlaceMapSheet) {
            OneMapView(promiseViewModel: promiseViewModel, destination: $destination, address: $address, coordXXX: $coordXXX, coordYYY: $coordYYY, sheetTitle: $sheetTitle)
        } // 약속장소 지도 sheet
        .sheet(isPresented: $isShowPenalty) {
            HStack {
                Spacer()
                Button {
                    isShowPenalty.toggle()
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
        } // 지각비 sheet
    } // body
} // struct

#Preview {
    AddPromiseView()
}
