//
//  EnumStore.swift
//  Zipadoo
//
//  Created by 윤해수 on 10/20/23.
//

import Foundation

/// 도착 타입 열거형
enum ArrivalType: String {
    case early = "일찍"
    case late = "늦게"
    case onTime = "에 딱 맞춰"
}

/// 프로필 이미지 사이즈 열거형
enum ProfileImageSize {
    case xSmall
    case mini
    case small
    case regular
    case medium
    case large
    
    var dimension: CGFloat {
        switch self {
        case .xSmall:
            return 30
        case .mini:
            return 50
        case .small:
            return 60
        case .regular:
            return 80
        case .medium:
            return 150
        case .large:
            return 200
        }
    }
}
