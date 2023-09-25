//
//  test3.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

struct Promise: Hashable {
    /// 약속 ID 값
    let id: String
    /// 약속 생성 사용자 ID 값
    let makingUserID: String
    /// 장소
    var destination: String
    /// 약속 제목
    var promiseTitle: String
    /// 참여자 ID 값
    var participantIdArray: [String]
    /// 약속 날짜
    var promiseDate: Double
    /// 약속 중복 값 확인
    var checkDoublePromise: Bool
    /// 밑에 Percentage모델 id 배열
    var percentageIdArray: [String] // 위에 participantsID대신에 이거는 어떠신가여
}
