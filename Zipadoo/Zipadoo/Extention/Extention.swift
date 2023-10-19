//
//  Extention.swift
//  Zipadoo
//
//  Created by 윤해수 on 2023/09/21.
//

// View extension을 위해 import
import SwiftUI

// View에서 키보드 숨기는 함수 extention
extension View {
    /// View에서 키보드 숨기는 함수
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    /// 뷰의 cornerRadius 모서리 마다 따로주기
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
