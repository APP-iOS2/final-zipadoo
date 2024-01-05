//
//  Tip.swift
//  Zipadoo
//
//  Created by 장여훈 on 1/5/24.
//

import Foundation
import TipKit

struct PromiseTip: Tip {
    var title: Text {
        Text("약속 생성")
    }
    
    var message: Text? {
        Text("여기를 눌러 약속을 만들 수 있어요!")
    }
    
    var image: Image? {
        Image("zipadoo")
    }
}

struct FriendsTip: Tip {
    var title: Text {
        Text("친구 추가")
    }
    
    var message: Text? {
        Text("여기를 눌러 친구 추가를 할 수 있어요!")
    }
    
    var image: Image? {
        Image("zipadoo")
    }
}
