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

enum SharingStatus: String {
    case preparing = "위치 공유 준비중"
    case sharing = "위치 공유중"
}

/// 약속 수정시 정보별 타입 - 약속이름, 날짜/시간, 장소, 지각비
enum PromiseCellType {
    case promiseTitle, promiseDate, promiseDestination, promisePenalty
    /// 셀타입에 따른 소제목
    func cellTitle(_ cellType: PromiseCellType) -> String {
        switch cellType {
        case .promiseTitle: return "약속 이름 수정"
        case .promiseDate: return "약속 날짜/시간 수정"
        case .promiseDestination: return "약속 장소 수정"
        case .promisePenalty: return "지각비 수정"
        }
    }
    // 시스템 이미지 이름
    func systemImageName(_ cellType: PromiseCellType) -> String {
        switch cellType {
        case .promiseDate: return "calendar"
        case .promiseDestination: return "location.magnifyingglass"
        case .promisePenalty: return "wonsign.circle"
        default: return ""
        }
    }
}
