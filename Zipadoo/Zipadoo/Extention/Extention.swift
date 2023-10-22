//
//  Extention.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

// View extension을 위해 import
import SwiftUI

// View의 Extension
extension View {
    /// View에서 키보드 숨기는 함수
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 약속 장소 도착시 띄워주는 Alert
    func arrivalMessageAlert (isPresented: Binding<Bool>, arrival: ArrivalMsgModel) -> some View {
        return modifier(ArrivalMessagingModifier(isPresented: isPresented, arrival: arrival)
        )
    }
    
    func profileImageModifier() -> some View {
        self.modifier(ImageStyleModifier())
    }
    
    /// 뷰의 cornerRadius 각 마다 따로주기
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}
