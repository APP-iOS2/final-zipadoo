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

struct ImageStyleModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
            .foregroundColor(Color.secondary)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.primary, lineWidth: 1)
            )
    } // body
} // struct
