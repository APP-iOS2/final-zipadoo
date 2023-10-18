//
//  ArriveResultView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct ArriveResultView: View {
    /// 약속 받아오기
    let promise: Promise
    // 정렬된 사람 결과
    @State var filteredLocation: [LocationAndParticipant] = []
    
    @ObservedObject private var locationStore = LocationStore()
    
    // 참여자의 순위나 지각여부등의 결과를 알려주는 텍스트
    var resultMessage: String = ""

    var body: some View {
        
        VStack {
            Text("참석자들의 도착 정보에요!")
                .padding()
            
            ScrollView {
                // 약속 정보뷰
                HStack {
                    VStack(alignment: .leading) {
                        PromiseDetailView(promise: promise).titleView
                        
                        PromiseDetailView(promise: promise).dateView
                        
                        PromiseDetailView(promise: promise).destinationView
                    }
                    Spacer()
                }
                .padding(.bottom, 10)
                
                Divider()
                    .padding(.bottom, 10)
                
                // 깃발
                HStack {
                    Image(systemName: "flag")
                        .padding(.leading, 18)
                    
                    Spacer()
                }
                // 참석자 결과 뷰
                ZStack {
                    // 선
                    HStack {
                        Rectangle()
                            .border(.secondary)
                            .frame(width: 2, height: 54 * CGFloat(locationStore.locationParticipantDatas.count))
                            .padding(.leading, 19)
                        Spacer()
                    }
                    
                    // 이미지쪽 원
//                    HStack {
//                        VStack {
//                            Spacer()
//                            ForEach(locationStore.locationParticipantDatas) { _ in
//                                
//                                Circle()
//                                    .fill(.orange)
//                                    .frame(width: 38, height: 38)
//                                    .border(.green)
////                                    .padding(.top, 1)
//                                    .padding(.bottom, 15)
//                                    
//                                    
//                            }
//                        }
//                        Spacer()
//                    }
//                    .padding(.leading, 6)

                    // 정보 행row
                    VStack {
                        Spacer()
                        
                        ForEach(locationStore.locationParticipantDatas) { participant in
                            
                            arrivedDataCell(participant: participant)
//                                .border(.red)
                                .padding(.bottom, 12)
                
                        }
                    }
                    .padding(.leading, 6)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))

            /*
            // 지각자
            ZStack {
                
                // conerRadius 적용위해 ZStack사용 했습니다
                Rectangle()
                    .cornerRadius(15)
                    .ignoresSafeArea()
                    .foregroundColor(.gray) // 임시 색
                    
                ScrollView {
                    ForEach(locationStore.locationParticipantDatas) { participant in
                        
                        arrivedDataCell(participant: participant)
                            .padding(.bottom, 12)
                    }
                }
                .padding()
                
            }
            .frame(height: UIScreen.main.bounds.size.height * 0.35)
             */
        }
        .onAppear {
            Task {
                // Location정보 패치
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
            }
            
        }
    }
    
    /// 약속 멤버 도착정보 행(row)
    private func arrivedDataCell(participant: LocationAndParticipant) -> some View {
        HStack {
            // 이미지
            ProfileImageView(imageString: participant.imageString, size: .xSmall)
                .clipShape(Circle())
                
            VStack(alignment: .leading) {
                
                Text(participant.nickname)
                    .fontWeight(.semibold)
                
                // -> ?뭘넣지
                Text("Comment")
                    .font(.footnote)
                
            }
            
            Spacer()
            
            Text(caculateResult(location: participant.location))
                .padding(3)
                .background(.yellow) // 임시 색
                .cornerRadius(5)
            
        }
    }
    
    /// 순위와 지각을 알려주는 함수로 메세지 결정
    private func caculateResult(location: Location) -> String {
        var message = ""
        /// 도착시간
        let arriveDate = Date(timeIntervalSince1970: location.arriveTime ?? 0)
        /// 약속시간
        let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
        
//        filteredLocation.map{ locationAndParticipant in
//            if locationAndParticipant.location.arriveTime != 0 && Calendar.current.dateComponents([.second], from: arriveDate, to: promiseDate).second ?? 0 >= 0 {
//                return location
//            }
//        }
        if location.arriveTime == 0 {
            message = "도착못함.."
        } else if Calendar.current.dateComponents([.second], from: arriveDate, to: promiseDate).second ?? 0 >= 0 {
            
            message = "도착"
        } else {
            message = "지각"
        }
        return message
    }
    
//    private func sortResult(participantArray: [LocationAndParticipant]) -> [LocationAndParticipant] {
//        if participantArray.location.arriveTime != 0 && Calendar.current.dateComponents([.second], from: arriveDate, to: promiseDate).second ?? 0 >= 0 {
//            return location
//        }
//        
//        return filteredLocation
//    }
}

#Preview {
    
    ArriveResultView(promise:
                        Promise(
                            id: "",
                            makingUserID: "3",
                            promiseTitle: "지각파는 두더지 모각코",
                            promiseDate: 1697101051.302136,
                            destination: "서울특별시 종로구 종로3길 17",
                            address: "",
                            latitude: 0.0,
                            longitude: 0.0,
                            participantIdArray: ["3", "4", "5"],
                            checkDoublePromise: false,
                            locationIdArray: ["35", "34", "89"]))
    
}
