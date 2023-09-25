//
//  UserModel.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import Foundation

struct User: Codable, Identifiable {
    /// 사용자 ID
    var id: String = UUID().uuidString
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
    var tardyCount: Int = 0
    /// 유저의 약속 수
//  let promiseCount: Int?
}
