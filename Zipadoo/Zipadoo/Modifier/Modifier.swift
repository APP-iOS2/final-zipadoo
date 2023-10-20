//
//  Modifier.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//  Modifier 정의
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
    } // body
} // struct

struct ArrivalMessagingModifier: ViewModifier {
    @Binding var isPresented: Bool
    var arrival: ArrivalMsgModel
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Rectangle()
                    .fill(.black.opacity(0.5))
                    .blur(radius: 0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.isPresented = false
                    }
                
                ArrivalMessagingView(isPresented: $isPresented, arrival: arrival)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        } // ZStack
        .animation(
            isPresented
            ? .spring(response: 0.5)
            : .none,
            value: isPresented
        )
    } // body
} // struct
