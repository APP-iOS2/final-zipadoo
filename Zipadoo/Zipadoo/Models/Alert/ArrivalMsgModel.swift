//
//  ArrivalMsgModel.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

struct ArrivalMsgModel {
    /// 사용자 이름
    let name: String
    /// 사용자 이미지
    let profileImgString: String
    /// 사용자 도착 순위
    let rank: Int
    /// 약속시간 - 사용자가 도착한 시간
    let arrivarDifference: Double
    /// 지각시 차감될 감자 수
    let potato: Int
}
