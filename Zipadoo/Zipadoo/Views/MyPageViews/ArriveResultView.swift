//
//  ArriveResultView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

/// 참여자들의 도착상태 enum
extension ArriveResultView {
    enum Result {
        case notLate
        case late
        case notArrive
    }
}
struct ArriveResultView: View {
    /// 약속 받아오기
    let promise: Promise
    // 정렬된 사람 결과
    @State var filteredLocation: [LocationAndParticipant] = []
    
    @ObservedObject private var locationStore = LocationStore()
    
    /// 약속시간
    var promiseDate: Date {
        return Date(timeIntervalSince1970: promise.promiseDate)
    }
    /// 시간표시 형식 지정
    let dateformat: DateFormatter = {
          let formatter = DateFormatter()
           formatter.dateFormat = "a h시 mm분 ss초"
           return formatter
       }()
    /// 얼마나 빨리/늦게 도착했는지
    let cacluateDateformat: DateFormatter = {
        let formatter = DateFormatter()
         formatter.dateFormat = "h시간 m분 s초"
         return formatter
     }()

    var body: some View {
        
        VStack {
            ScrollView {
                // MARK: - 약속 정보뷰
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
                
                // MARK: - 참석자 결과 뷰
                // 깃발
                HStack {
                    Image(systemName: "flag")
                        .padding(.leading, 13)
                        .font(.title2)
                    
                    Spacer()
                }

                ZStack {
                    // 세로선
                    HStack {
                        Rectangle()
                            .foregroundStyle(.secondary)
                            .frame(width: 2, height: 58 * CGFloat(locationStore.locationParticipantDatas.count))
                            .padding(.leading, 16)
                        Spacer()
                    }

                    // 정보 행row
                    VStack {
                        Spacer()
                        
                        ForEach(locationStore.sortResult(resultArray: locationStore.locationParticipantDatas)) { participant in
                            
                            arrivedDataCell(participant: participant)
                                .padding(.top, 12)
                        }
                    }
//                    .padding(.leading, 6)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
//            .padding()
        }
        .onAppear {
            Task {
                // Location정보 패치
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                
            }
            
        }
    }
    
    // MARK: - 함수
    /// 약속 멤버 도착정보 행(row)
    private func arrivedDataCell(participant: LocationAndParticipant) -> some View {
        var resultEnum: Result = .notArrive
        /// 등수/지각 표시메세지
        var resultMessage = ""
        /// 등수/지각에 따른 텍스트 색
        var resultColor: Color = .primary
        /// 시간차이
        var calculateInt: Int = Int(promise.promiseDate - participant.location.arriveTime)
        /// 시간차이를 시,분,초로 바꾸기
        var calculateTimeString: String {

            let hour = calculateInt / 3600
            calculateInt %= 3600
            let minute = calculateInt / 60
            let second = calculateInt % 60
            
            // 반환할 문자열
            var timeString: String = ""
            if hour != 0 {
                timeString += "\(hour)시간"
            }
            if minute != 0 {
                timeString += "\(minute)분"
            }
            if second != 0 {
                timeString += "\(second)초"
            }
            
            return timeString
        }
        /// 3등안에 들면 왕관
        var isCrown: Bool = false
        
        // 등수/지각여부 확인 분기문
        if participant.location.rank == 0 {
            resultColor = .secondary
        } else {
            if calculateInt < 0 {
                resultMessage = "지각!"
                resultColor = .red
                calculateInt *= -1
                resultEnum = .late
            } else {
                resultMessage = "\(participant.location.rank)등"
                if participant.location.rank < 4 {
                    isCrown = true
                }
                resultEnum = .notLate
            }
        }
        
        // 반환하는 View
        return HStack {
            // 이미지
            ZStack {
                Circle()
                    .fill(.gray)
                    .frame(width: 36, height: 36)
                
                ProfileImageView(imageString: participant.imageString, size: .xSmall)
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading) {
                // 닉네임
                Text(participant.nickname)
                    .fontWeight(.semibold)
                
                // 도착한 시간
                if resultEnum == .notArrive {
                    Text("도착정보가 없어요")
                        .font(.footnote)
                        .foregroundStyle(resultColor)
                    
                } else if resultEnum == .late {
                    Text("\(calculateTimeString) 늦게 도착")
                        .font(.footnote)
                        .foregroundStyle(resultColor)
                    
                } else if resultEnum == .notLate {
                    Text("\(calculateTimeString) 일찍 도착")
                        .font(.footnote)
                        .foregroundStyle(resultColor)
                }
            }
            
            Spacer()
            
            if isCrown {
                Text(Image(systemName: "crown"))
            }
            // 등수표기/지각 여부
            Text(resultMessage)
                .padding(3)
                .foregroundColor(resultColor)

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
                            locationIdArray: ["35", "34", "89"],
                            penalty: 0))
    
}
