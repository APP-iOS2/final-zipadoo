//
//  UserModel.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import Foundation

struct User: Codable, Identifiable, Equatable {
    /// 사용자 ID
    var id: String
    /// 사용자 이름
    let name: String
    /// 사용자 닉네임
    var nickName: String
    /// 사용자 핸드폰 번호
    var phoneNumber: String
    /// 포인트
    var potato: Int = 0
    /// 유저 이미지
    var profileImageString: String
    /// 지각 심도
    var crustDepth: Int = 0
    /// 유저의 지각 약속 수
    var tradyCount: Int = 0
    /// 친구 id 배열
    var friendsIdArray: [String]
    /// 친구요청 id배역
    var friendsIdRequestArray: [String]
    /// 총 약속수
    var promiseCount: Int = 0
    /// 유저 두더지 이미지
    var moleImageString: String
    /// 유저 두더지 드릴 이미지
    var moleDrillImageString: String {
        return "\(moleImageString)_1"
    }
}

extension User {
    static let sampleData: User = .init(id: "1234", name: "홍길동", nickName: "길똥이", phoneNumber: "010-1234-5678", profileImageString: "https://img1.daumcdn.net/thumb/C500x500/?fname=http://t1.daumcdn.net/brunch/service/user/6qYm/image/eAFjiZeA-fGh8Y327AH7oTQIsxQ.png", crustDepth: 4, friendsIdArray: ["12345","123456"], friendsIdRequestArray: [], moleImageString: "doo1")
}
