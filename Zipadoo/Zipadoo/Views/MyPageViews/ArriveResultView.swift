//
//  ArriveResultView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

/// 지각 안한 사람 닉네임
var dummyPercentage = ["닉넴1", "닉넴2", "닉넴3", "닉넴4", "닉넴4", "닉넴4", "닉넴4"]
/// 지각자 닉네임
var lateCommer = ["지각자1", "지각자2", "지각자3"]

struct ArriveResultView: View {
    /// 약속 받아오기
    let promise: Promise
    
    @StateObject private var locationStore = LocationStore()
    
    // 참여자의 순위나 지각여부등의 결과를 알려주는 텍스트
    var resultMessage: String = ""

    var body: some View {
        
        VStack {
            Text("참석자들의 도착 정보에요!")
                .padding()
            
            ScrollView {
                ForEach(locationStore.locationParticipantDatas) { participant in
                    
                    arrivedDataCell(participant: participant)
                        .padding(.bottom, 12)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
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
            
            VStack(alignment: .leading) {
                
                Text(participant.nickname)
                    .fontWeight(.semibold)
                // -> ?뭘넣지
                Text("Comment")
                    .font(.footnote)
                
            }
            
            Spacer()
            
            // 순위와 지각을 알려주는 함수로 메세지 결정
            Text(caculateResult(location: participant.location))
                .padding(3)
                .background(.yellow) // 임시 색
                .cornerRadius(5)
            
        }
    }
    
    private func caculateResult(location: Location) -> String {
        var message = ""
        /// 도착시간
        let arriveDate = Date(timeIntervalSince1970: location.arriveTime ?? 0)
        /// 약속시간
        let promiseDate = Date(timeIntervalSince1970: promise.promiseDate)
        
        if location.arriveTime == 0 {
            message = "도착못함.."
        } else if Calendar.current.dateComponents([.second], from: arriveDate, to: promiseDate).second ?? 0 >= 0 {
            message = "도착"
        } else {
            message = "지각"
        }
        return message
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
