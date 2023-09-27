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
}
