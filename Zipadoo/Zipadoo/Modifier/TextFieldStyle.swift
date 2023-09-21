//
//  TextFieldStyle.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct TextFieldStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .padding(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray)
            )
    }
}
