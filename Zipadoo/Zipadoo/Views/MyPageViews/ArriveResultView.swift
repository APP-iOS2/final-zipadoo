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
    
    /// 약속시간
    var promiseDate: Date {
        Date(timeIntervalSince1970: promise.promiseDate)
    }
    /// 시간표시 형식 지정
    let dateformat: DateFormatter = {
          let formatter = DateFormatter()
           formatter.dateFormat = "a h시 mm분 ss초"
           return formatter
       }()

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
                        
                        ForEach(locationStore.sortResult(resultArray: locationStore.locationParticipantDatas)) { participant in
                            
                            arrivedDataCell(participant: participant)
//                                .border(.red)
                                .padding(.bottom, 12)
                
                        }
                    }
                    .padding(.leading, 6)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
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
        
        /// 참여자 도착시간
        let arriveDate = Date(timeIntervalSince1970: participant.location.arriveTime)
        /// 등수/지각 표시메세지
        var resultMessage = ""
        /// 등수/지각에 따른 텍스트 색
        var resultColor: Color = .primary
        /// 도착시간 ~ 약속시간까지의 차이
        var calculateDate = Calendar.current.dateComponents([.second], from: arriveDate, to: promiseDate).second ?? 0
        
        // 등수/지각여부 확인 분기문
        if participant.location.rank == 0 {
//            resultMessage = "도착못함"
            resultColor = .secondary
        } else {
            if calculateDate < 0 {
                resultMessage = "지각!"
                resultColor = .red
            } else {
                resultMessage = "\(participant.location.rank)등"
//                Label("\(participant.location.rank)등", systemImage: "crown")
            }
        }
        
        // 반환하는 View
        return HStack {
            // 이미지
            ProfileImageView(imageString: participant.imageString, size: .xSmall)
                .clipShape(Circle())
                
            VStack(alignment: .leading) {
                // 닉네임
                Text(participant.nickname)
                    .fontWeight(.semibold)
                
                // 도착한 시간
                if participant.location.arriveTime == 0 {
                    Text("도착정보가 없어요")
                        .font(.footnote)
                        .foregroundStyle(resultColor)
                    
                } else {
//                    Text(dateformat.string(from: Calendar.current.date(byAdding: .hour, value: 9, to: arriveDate) ?? promiseDate))
                    Text("\(dateformat.string(from: arriveDate)) 도착")
                        .font(.footnote)
                        .foregroundStyle(resultColor)
                }
            }
            
            Spacer()
            
            // 등수표기/지각 여부
            Text(resultMessage)
                .padding(3)
                .foregroundColor(resultColor)
//                .background(.yellow) // 임시 색
//                .cornerRadius(5)
            
        }
    }

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
