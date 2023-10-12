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
    @State private var selectedFriends: [String] = []
    @State var promiseLocation: PromiseLocation = PromiseLocation(id: "123", destination: "", address: "", latitude: 37.5665, longitude: 126.9780)
    @StateObject var editPromise: PromiseViewModel = PromiseViewModel()
    @StateObject private var authUser: AuthStore = AuthStore()
    
    @State private var destination: String = "" // 약속 장소 이름
    @State private var address = "" // 약속장소 주소
    @State private var coordX = 0.0 // 약속장소 위도
    @State private var coordY = 0.0 // 약속장소 경도
    @State var isClickedPlace: Bool = false /// 검색 결과에 나온 장소 클릭값
    @State var addLocationButton: Bool = false /// 장소 추가 버튼 클릭값

    private let dbRef = Firestore.firestore().collection("Promise")
    
    var body: some View {
        NavigationView {
            Form {
                Text("약속 장소")
                    .font(.title2)
                    .bold()
                
                if promiseLocation.destination.isEmpty {
                    Text("\(editedDestination)")
                } else {
                    Text("\(promiseLocation.destination)")
                }
                
                HStack {
                    NavigationLink {
                        AddPlaceOptionCell(isClickedPlace: $isClickedPlace, addLocationButton: $addLocationButton, destination: $destination, address: $address, coordX: $coordX, coordY: $coordY, promiseLocation: $promiseLocation)
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
                
//                AddFriendCellView(selectedFriends: Binding<[User]>)
                
            }
            .onAppear {
                editedPromiseTitle = promise.promiseTitle
                editedDestination = promise.destination
                editedPromiseDate = Date(timeIntervalSince1970: promise.promiseDate)
                selectedFriends = promise.participantIdArray
            }
            .navigationBarItems(
                trailing: Button("저장") {
                    updatePromise()
                    dismiss()
                }
            )
            .navigationTitle("약속 수정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func updatePromise() {
        let promiseRef = dbRef.document(promise.id)

        let updatedData: [String: Any] = [
            "promiseTitle": editedPromiseTitle,
            "promiseDate": editedPromiseDate.timeIntervalSince1970,
            "destination": editedDestination,
            "participantIdArray": selectedFriends
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

//#Preview {
//    PromiseEditView()
//}
